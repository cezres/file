//
//  ImageEntity.swift
//  file
//
//  Created by 翟泉 on 2016/10/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import FastImageCache




class ImageEntity: NSObject, FICEntity {
    
    open override class func initialize() {
        
    }
    
    
    var url: URL!
    
    init(url: URL) {
        self.url = url
    }
    
    var identifier: String!
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    lazy var _uuid: String = {
        let imageName: String
        if self.url != nil {
            imageName = self.url.absoluteString.urlDecode.relativePath
        }
        else {
            imageName = self.identifier
        }
        let UUIDBytes = FICUUIDBytesWithString(imageName)
        return FICStringWithUUIDBytes(UUIDBytes)
    }()
    
    // MARK: - FICEntity
    
    @objc(UUID) var uuid: String! {
        return self._uuid
    }
    
    var sourceImageUUID: String! {
        return self.uuid
    }
    
    func sourceImageURL(withFormatName formatName: String!) -> URL! {
        return url
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
            
            UIGraphicsPushContext(context)
            if formatName == ImageCacheFormat.icon.rawValue {
                image.square().draw(in: contextBounds)
            }
            else {
                image.draw(in: contextBounds)
            }
            UIGraphicsPopContext()
        }
    }
    
    
}
