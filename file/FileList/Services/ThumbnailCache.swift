//
//  ESThumbnailCache.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit



class ThumbnailCache: NSCache, NSCacheDelegate {
    static let sharedInstance = ThumbnailCache()
    
    
    func loadThumbnail(path: String, width: CGFloat, callback: (path: String, thumbnail: UIImage)->Void) {
        guard path != "" && width > 0 else {
            return
        }
        
        // 因为 Document路径 会在App重新运行的时候发生改变
        var xdPath = path
        xdPath.removeRange(path.rangeOfString(DocumentDirectory())!)
        
        
        let thumbnailCacheDirectory = CachesDirectory() + "/thumbnail/\(Int(width))"
        let thumbnailCachePath = thumbnailCacheDirectory + "/\(xdPath.hashValue)"
        
        if let thumbnail = objectForKey(thumbnailCachePath) as? UIImage {
            // 内存
            callback(path: path, thumbnail: thumbnail)
        }
        else if let thumbnail = UIImage(contentsOfFile: thumbnailCachePath) {
            // 硬盘
            callback(path: path, thumbnail: thumbnail)
            setObject(thumbnail, forKey: thumbnailCachePath)
        }
        else {
            // 重新生成缩略图
            dispatch_async(dispatch_get_global_queue(0, 0), {
                var flag: ObjCBool = false
                NSFileManager.defaultManager().fileExistsAtPath(thumbnailCacheDirectory, isDirectory: &flag)
                if !flag {
                    do {
                        try NSFileManager.defaultManager().createDirectoryAtPath(thumbnailCacheDirectory, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch {
                        print(error)
                        return
                    }
                }
                
                guard let image = UIImage(contentsOfFile: path) else {
                    return
                }
                
                let thumbnail = image.scale(width * UIScreen.mainScreen().scale).square()
                
                dispatch_async(dispatch_get_main_queue(), {
                    callback(path: path, thumbnail: thumbnail)
                })
                
                self.setObject(thumbnail, forKey: thumbnailCachePath)
                UIImagePNGRepresentation(thumbnail)?.writeToFile(thumbnailCachePath, atomically: true)
            })
        }
        
    }
    
    
    
    private override init() {
        super.init()
        name       = NSStringFromClass(classForCoder)
        countLimit = 60
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ESImageCache.didReceiveMemoryWarning),
            name: UIApplicationDidReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    func didReceiveMemoryWarning() {
        removeAllObjects()
    }
}
