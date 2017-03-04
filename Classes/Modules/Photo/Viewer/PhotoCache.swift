//
//  PhotoCache.swift
//  file
//
//  Created by 翟泉 on 2017/3/4.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import PINCache
import FastImageCache

typealias PhotoCacheBlock = (UIImage?, URL) -> Swift.Void

fileprivate let PhotoCacheFormatName = "PhotoCacheFormatName"
fileprivate let PhotoFormatFamily = "PhotoFormatFamily"

class PhotoCache {
    
    static let shared = PhotoCache()
    
    var memoryCache: PINMemoryCache!
    
    let imageCache: FICImageCache = FICImageCache(nameSpace: "PhotoCache")
    
    init() {
        let operationQueue = PINOperationQueue(maxConcurrentOperations: 4, concurrentQueue: DispatchQueue(label: "PhotoCache"))
        memoryCache = PINMemoryCache(operationQueue: operationQueue)
        
        let imageSize = UIScreen.main.bounds.size
        let photoFormat = FICImageFormat(name: PhotoCacheFormatName, family: PhotoFormatFamily, imageSize: imageSize, style: .style32BitBGR, maximumCount: 200, devices: .phone, protectionMode: .none)!
        imageCache.setFormats([photoFormat])
        
    }
    
    
    func photo(forURL url: URL, complete block: @escaping PhotoCacheBlock) {
        let photoEntity = PhotoCacheEntity(url: url)
        
        imageCache.retrieveImage(for: photoEntity, withFormatName: PhotoCacheFormatName) { (entity, _, image) in
            guard let entity = entity as? PhotoCacheEntity else {
                return
            }
            block(image, entity.url)
        }
    }

}


class PhotoCacheEntity: NSObject, FICEntity {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    lazy var _uuid: String = {
        let UUIDBytes = FICUUIDBytesFromMD5HashOfString(self.url.path.relativePath)
        let UUID = FICStringWithUUIDBytes(UUIDBytes)
        return UUID!
    }()
    
    @objc(UUID) var uuid: String! {
        return _uuid
    }
    
    var sourceImageUUID: String! {
        return _uuid
    }
    
    func sourceImageURL(withFormatName formatName: String!) -> URL! {
        return url
    }
    
    func image(for format: FICImageFormat!) -> UIImage! {
        return UIImage(contentsOfFile: url.path)
    }
    
    func drawingBlock(for image: UIImage!, withFormatName formatName: String!) -> FICEntityImageDrawingBlock! {
        return { (context: CGContext?, contextSize: CGSize) -> Void in
            guard let context = context else {
                return
            }
            var contextBounds = CGRect()
            contextBounds.size = contextSize
            context.clear(contextBounds)
            context.setFillColor(UIColor.white.cgColor)
            context.fill(contextBounds)
            
            let drawRect: CGRect
            let contextAspectRatio = contextSize.width / contextSize.height
            let imageAspectRatio = image.size.width / image.size.height
            if contextAspectRatio == imageAspectRatio {
                drawRect = CGRect(origin: CGPoint.zero, size: contextSize)
            }
            else if contextAspectRatio > imageAspectRatio {
                let drawWidth = contextSize.height * imageAspectRatio
                drawRect = CGRect(x: (contextSize.width - drawWidth) / 2, y: 0, width: drawWidth, height: contextSize.height)
            }
            else {
                let drawHeight = contextSize.width * image.size.height / image.size.width
                drawRect = CGRect(x: 0, y: (contextSize.height - drawHeight) / 2, width: contextSize.width, height: drawHeight)
            }
            
            UIGraphicsPushContext(context)
            image.draw(in: drawRect)
            UIGraphicsPopContext()
        }
    }
    
}


class PhotoThumbnail {
    
}







