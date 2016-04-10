//
//  Cache.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/4/5.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit


/// 缓存
class ESImageCache: NSCache, NSCacheDelegate {
    
    static let sharedInstance = ESImageCache()
    
    private override init() {
        super.init()
        name       = NSStringFromClass(classForCoder)
        countLimit = 10
        delegate   = self
        
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
    
    override func setObject(obj: AnyObject, forKey key: AnyObject) {
        super.setObject(obj, forKey: key)
    }
    
    // MARK: - NSCacheDelegate
    func cache(cache: NSCache, willEvictObject obj: AnyObject) {
        
    }
}

/// 缩略图缓存
class ESThumbnailCache: NSCache, NSCacheDelegate {
    
    static let sharedInstance = ESThumbnailCache()
    
    private override init() {
        super.init()
        name       = NSStringFromClass(classForCoder)
        countLimit = 40
        delegate   = self
        
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
    
    override func setObject(obj: AnyObject, forKey key: AnyObject) {
        super.setObject(obj, forKey: key)
    }
    
    // MARK: - NSCacheDelegate
    func cache(cache: NSCache, willEvictObject obj: AnyObject) {
        
    }
}