//
//  PhotoView.swift
//  file
//
//  Created by 翟泉 on 2017/3/4.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoView: UIView {
    
    let imageNode = ASImageNode()
    
    var url: URL! {
        didSet {
            guard oldValue != url else {
                return
            }
            
            imageNode.image = nil
            
            DispatchQueue.global().async { [weak self] in
                guard let imageUrl = self?.url else {
                    return
                }
                if let image = PhotoMemoryCache.shared().object(forKey: imageUrl.path) as? UIImage {
                    DispatchQueue.main.async {
                        guard imageUrl == self?.url else {
                            return
                        }
                        self?.imageNode.image = image
                        self?.setupImageNodeFrame()
                    }
                    print("缓存: \(imageUrl.lastPathComponent)")
                }
                else {
                    if let image = loadImage(url: imageUrl) {
                        DispatchQueue.main.async {
                            guard imageUrl == self?.url else {
                                return
                            }
                            self?.imageNode.image = image
                            self?.setupImageNodeFrame()
                        }
                        PhotoMemoryCache.shared().setObject(image, forKey: self!.url.path)
                        print("硬盘: \(imageUrl.lastPathComponent)")
                    }
                }
            }
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageNode.backgroundColor = UIColor.white
        addSubnode(imageNode)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImageNodeFrame()
    }
    
    func setupImageNodeFrame() {
        let contextSize = bounds.size
        guard let imageSize = imageNode.image?.size else {
            imageNode.frame = bounds
            return
        }
        let contextAspectRatio = contextSize.width / contextSize.height
        let imageAspectRatio = imageSize.width / imageSize.height
        if contextAspectRatio == imageAspectRatio {
            imageNode.frame = CGRect(origin: CGPoint.zero, size: contextSize)
        }
        else if contextAspectRatio > imageAspectRatio {
            let drawWidth = contextSize.height * imageAspectRatio
            imageNode.frame = CGRect(x: (contextSize.width - drawWidth) / 2, y: 0, width: drawWidth, height: contextSize.height)
        }
        else {
            let drawHeight = contextSize.width * imageSize.height / imageSize.width
            imageNode.frame = CGRect(x: 0, y: (contextSize.height - drawHeight) / 2, width: contextSize.width, height: drawHeight)
        }
    }

}


func loadImage(url: URL) -> UIImage? {
    var imageData: Data!
    do {
        imageData = try Data(contentsOf: url)
    }
    catch {
        return nil
    }
    guard let mimeType = MIMEType(pathExtension: url.pathExtension) else { return nil }
    guard let dataProvider = CGDataProvider(data: imageData as CFData) else { return nil }
    var cgImage: CGImage!
    if mimeType == "image/png" {
        cgImage = CGImage(pngDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
    }
    else if mimeType == "image/jpeg" {
        cgImage = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        if cgImage != nil {
            let imageColorSpace = cgImage.colorSpace
            let imageColorSpaceModel = imageColorSpace?.model
            if imageColorSpaceModel == CGColorSpaceModel.cmyk {
                cgImage = nil
            }
        }
    }
    if cgImage == nil {
        return nil
    }
    let width = cgImage.width
    let height = cgImage.height
    let bitsPerComponent = cgImage.bitsPerComponent
    let bytesPerRow = ByteAlignForCoreAnimation(bytesPerRow: width * 4)
    let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
    let context: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo)!
    context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
    let inflatedCGImage = context.makeImage()!
    return UIImage(cgImage: inflatedCGImage)
}

func ByteAlignForCoreAnimation(bytesPerRow: Int) -> Int {
    return ((bytesPerRow + (64 - 1)) / 64) * 64
}
