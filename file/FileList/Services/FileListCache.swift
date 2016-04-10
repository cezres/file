//
//  FileListCache.swift
//  file
//
//  Created by 翟泉 on 16/4/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


class FileListCache: NSCache, NSCacheDelegate {
    static let sharedInstance = FileListCache()
    private override init() {
        super.init()
        delegate = self
        countLimit = 4
    }
    
    //MARK: - NSCacheDelegate
    func cache(cache: NSCache, willEvictObject obj: AnyObject) {
        
    }
}
