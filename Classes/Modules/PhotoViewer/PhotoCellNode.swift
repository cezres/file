//
//  PhotoCellNode.swift
//  file
//
//  Created by 翟泉 on 2017/2/15.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FastImageCache
import PINCache

class PhotoCellNode: ASCellNode {
    
    let _imageNode = ASImageNode()
    
   // var _entity: ImageEntity!
    
    init(url: URL) {
        super.init()
        _imageNode.contentMode = UIViewContentMode.scaleAspectFit
        addSubnode(_imageNode)
        
      //  _entity = ImageEntity(url: url)
        
      //  PINCache.shared()
        
        
        
        
        if let image = PhotoMemoryCache.shared().object(forKey: url.path) as? UIImage {
            _imageNode.image = image
            print("缓存: \(url.lastPathComponent)")
        }
        else {
            if let image = UIImage(contentsOfFile: url.path) {
                _imageNode.image = image
                PhotoMemoryCache.shared().setObject(image, forKey: url.path)
                print("硬盘: \(url.lastPathComponent)")
            }
        }
        
        /*
        if FICImageCache.shared().imageExists(for: _entity, withFormatName: "Photo") {
            FICImageCache.shared().retrieveImage(for: _entity, withFormatName: "Photo", completionBlock: { [weak self](entity, formatName, image) in
                guard self != nil else {
                    return
                }
                self?._imageNode.image = image
            })
        }
        else {
            if let image = UIImage(contentsOfFile: url.path) {
                _imageNode.image = image
                FICImageCache.shared().setImage(image, for: _entity, withFormatName: "Photo", completionBlock: { (entity, formatName, image) in
                    
                })
            }
            
            
        }*/
        
        /*
        ImageCache.retrieveImage(url: url, format: ImageCacheFormat.photo) { [weak self](url, image) in
            guard self != nil else {
                return
            }
            if image != nil {
                self?.imageNode.image = image
            }
            else {
                
            }
        }*/
        
    }
    
    override func layout() {
        super.layout()
        _imageNode.frame = bounds
    }
    
}
