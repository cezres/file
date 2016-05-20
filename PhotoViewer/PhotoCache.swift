//
//  PhotoCache.swift
//  file
//
//  Created by 翟泉 on 16/5/19.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit



class PhotoCache {
    
    static let sharedInstance = PhotoCache()
    
    let imageCache = NSCache()
    let thumbnailCache = NSCache()
    
    var callbacks = [PhotoCacheCallback]()
    
    var loading = [String]()
    
    let queue = NSOperationQueue()
    
    init() {
        imageCache.countLimit = 4
        thumbnailCache.countLimit = 20
        
        queue.maxConcurrentOperationCount = 3
    }
    
    func imageForPath(filePath: String, callback: (filePath: String, image: UIImage)->Void) {
        // ImageCache
        if let image = imageCache.objectForKey(filePath) as? UIImage {
            callback(filePath: filePath, image: image)
            print("ImageCache", filePath.photo_lastPathComponent)
            return
        }
        // ThumbnailCache
        if let thumbnail = thumbnailCache.objectForKey(filePath) as? UIImage {
            callback(filePath: filePath, image: thumbnail)
            print("ThumbnailCache", filePath.photo_lastPathComponent)
        }
        // LoadImage
        callbacks.append(PhotoCacheCallback(filePath: filePath, callback: callback))
        
        for path in loading {
            if path == filePath {
                return
            }
        }
        
        asyncLoadImage(filePath)
    }
    
    func loadImage(filePath: String) {
        if (imageCache.objectForKey(filePath) as? UIImage) != nil {
            return
        }
        asyncLoadImage(filePath)
    }
    
    func asyncLoadImage(filePath: String) {
        loading.append(filePath)
        
        queue.addOperationWithBlock { 
            print(NSThread.currentThread(), filePath.photo_lastPathComponent)
            guard let image = UIImage(contentsOfFile: filePath) else {
                return
            }
            
//            NSThread.sleepForTimeInterval(0.5)
//            sleep(3)
            
            print("LoadImage", filePath.photo_lastPathComponent)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                for (idx, path) in self.loading.enumerate() {
                    if path == filePath {
                        self.loading.removeAtIndex(idx)
                        break
                    }
                }
                
                let cbs = self.callbacks
                for (idx,callback) in cbs.enumerate() {
                    if callback.filePath == filePath {
                        callback.callback(filePath: filePath, image: image)
                        let index = idx - (cbs.count - self.callbacks.count)
                        self.callbacks.removeAtIndex(index)
                    }
                }
                
            })
            
            
            self.imageCache.setObject(image, forKey: filePath)
            self.thumbnailCache.setObject(image.photo_thumbnail(), forKey: filePath)
        }
        
        /*
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            print(NSThread.currentThread(), filePath.photo_lastPathComponent)
            guard let image = UIImage(contentsOfFile: filePath) else {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                for (idx, path) in self.loading.enumerate() {
                    if path == filePath {
                        self.loading.removeAtIndex(idx)
                        break
                    }
                }
                
                var idxs = [Int]()
                
                for (idx,callback) in self.callbacks.enumerate() {
                    if callback.filePath == filePath {
                        callback.callback(filePath: filePath, image: image)
                        print("LoadImage", filePath.photo_lastPathComponent)
                        idxs.append(idx)
                    }
                }
                
                for idx in idxs {
                    self.callbacks.removeAtIndex(idx)
                }
                
            })
            
            self.imageCache.setObject(image, forKey: filePath)
            self.thumbnailCache.setObject(image.photo_thumbnail(), forKey: filePath)
        }*/
    }
    
    
    func removeAllCache() {
        imageCache.removeAllObjects()
        thumbnailCache.removeAllObjects()
    }
    
}

struct PhotoCacheCallback {
    let filePath: String
    let callback: (filePath: String, image: UIImage) -> Void
}
