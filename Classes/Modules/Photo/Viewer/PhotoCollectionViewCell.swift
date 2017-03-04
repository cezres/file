//
//  PhotoCollectionViewCell.swift
//  file
//
//  Created by 翟泉 on 2017/2/15.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //let imageView = UIImageView()
    
    let imageNode = ASImageNode()
    
    
    var url: URL! {
        didSet {
            imageNode.image = nil
            
            DispatchQueue.global().async { [weak self] in
                guard self != nil else {
                    return
                }
                PhotoCache.shared.photo(forURL: self!.url, complete: { (image, url) in
                    guard image != nil && url == self?.url else {
                        return
                    }
                    self?.imageNode.image = image
                })
            }
            /*
            DispatchQueue.global().async { [weak self] in
                guard self != nil else {
                    return
                }
                if let image = PhotoMemoryCache.shared().object(forKey: self!.url.path) as? UIImage {
                    self!.imageNode.image = image
                    print("缓存: \(self!.url.lastPathComponent)")
                }
                else {
                    
                    var imageData: Data!
                    do {
                        imageData = try Data(contentsOf: self!.url)
                    }
                    catch {
                        return
                    }
                    guard let mimeType = MIMEType(pathExtension: self!.url.pathExtension) else { return }
                    guard let dataProvider = CGDataProvider(data: imageData as CFData) else { return }
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
                        return
                    }
                    let width = cgImage.width
                    let height = cgImage.height
                    let bitsPerComponent = cgImage.bitsPerComponent
                    let bytesPerRow = self!.ByteAlignForCoreAnimation(bytesPerRow: width * 4)
                    let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
                    let context: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo)!
                    context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
                    let inflatedCGImage = context.makeImage()!
                    let inflatedImage = UIImage(cgImage: inflatedCGImage)
 
                    
//                    let image = UIImage(contentsOfFile: self!.url.path)
 
                    self!.imageNode.image = inflatedImage
                    PhotoMemoryCache.shared().setObject(inflatedImage, forKey: self!.url.path)
                    print("硬盘: \(self!.url.lastPathComponent)")
                    
                    
                }
            }
            */
            
        }
    }
    
    func ByteAlignForCoreAnimation(bytesPerRow: Int) -> Int {
        return ((bytesPerRow + (64 - 1)) / 64) * 64
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageNode.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubnode(imageNode)
        contentView.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageNode.frame = bounds
    }
    
    
    
    
}
