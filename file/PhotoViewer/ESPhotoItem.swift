//
//  ESPhotoItem.swift
//  ESPhotoViewer
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit

public class ESPhotoItem {
    
    public var url: NSURL!
    
    public var index: Int = 0
    
    func getImage(callback: (image: UIImage)-> Void) {
        guard let url = self.url else {
            return
        }
        guard url.fileURL else {
            return
        }
        
        if let image = ESImageCache.sharedInstance.objectForKey(url.absoluteString) as? UIImage {
            callback(image: image)
        }
        else {
            if let thumbnail: UIImage = ESThumbnailCache.sharedInstance.objectForKey(url.absoluteString) as? UIImage {
                callback(image: thumbnail)
            }
            asyncLoadImage(url.copy() as! NSURL, callback: callback)
        }
        
    }
    
    
    func asyncLoadImage(url: NSURL, callback: (image: UIImage)-> Void) {
        
        func loadImage(url: NSURL) -> UIImage? {
            
            let resultImage: UIImage?
            
            if let imageData = NSData(contentsOfURL: url) {
                resultImage = UIImage(data: imageData)
            }
            else {
                resultImage = nil
            }
            
            sleep(2)
            
            return resultImage
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), {
            
            if let image = loadImage(url) {
                if url.isEqual(self.url) {
                    dispatch_async(dispatch_get_main_queue(), {
                        callback(image: image)
                    })
                }
                ESImageCache.sharedInstance.setObject(image, forKey: url.absoluteString)
                ESThumbnailCache.sharedInstance.setObject(image.es_thumbnail(), forKey: url.absoluteString)
            }
        })
    }
    
}

extension ESPhotoItem: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return url.absoluteString + " \(index)"
    }
    public var debugDescription: String {
        return url.absoluteString + " \(index)"
    }
}







