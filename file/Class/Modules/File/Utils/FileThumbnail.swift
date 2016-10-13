//
//  FileThumbnail.swift
//  file
//
//  Created by 翟泉 on 2016/9/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

typealias FileThumbnailBlock = (_ file: File, _ image: UIImage) -> Void

/// 文件缩略图缓存
class FileThumbnailCache {
    
    
    static let shared = FileThumbnailCache()
    
    struct FileThumbnailCallback {
        let file: File
        let block: FileThumbnailBlock
    }
    
    
    /**
     清除所有缓存
     */
    class func removeAllCache() {
        shared.cache.removeAllObjects()
    }
    
    /**
     获取文件缩略图
     
     - parameter view:  <#view description#>
     - parameter file:  <#file description#>
     - parameter block: <#block description#>
     */
    class func thumbnail(hashValue: Int, file: File, block: @escaping FileThumbnailBlock) {
        
        if let result = shared.cache.object(forKey: NSNumber(value: file.hashValue)) {
            block(file, result)
            return
        }
        appendCallback(hash: hashValue, file: file, block: block)
        if file.isIn(collection: shared.operations) {
            return
        }
        appendOperation(file: file)
        
        FileThumbnailQueue.addOperation { 
            var image: UIImage!
            defer {
                removeOperation(file: file)
                self.callback(file: file, image: image)
            }
            
            image = self.thumbnail(file: file)?.decode()
            
            shared.cache.setObject(image, forKey: NSNumber(value: file.hashValue))
            
        }
        
        
        
    }
    
    // MARK: - Private
    
    private let cache = NSCache<NSNumber, UIImage>()
    
    private static let FileThumbnailQueue = OperationQueue()
    
    private init() {
        cache.countLimit = 10
    }
    
    private class func thumbnail(file: File) -> UIImage? {
        switch file.type {
        case .Directory:
            return UIImage(named: "icon_directory")
        case .Audio:
            return UIImage(named: "icon_audio")
        case .Video:
            return UIImage(named: "icon_video")
        case .Zip:
            return UIImage(named: "icon_zip")
        case .Photo:
            return UIImage(contentsOfFile: file.path)
        default:
            return UIImage(named: "icon_unknown")
        }
    }
    
    
    // MARK: Operation
    
    private var operations = [File]()
    private var operationsLock: OSSpinLock = OS_SPINLOCK_INIT
    
    private class func appendOperation(file: File) {
        OSSpinLockLock(&shared.operationsLock)
        defer {
            OSSpinLockUnlock(&shared.operationsLock)
        }
        shared.operations.append(file)
    }
    private class func removeOperation(file: File) {
        OSSpinLockLock(&shared.operationsLock)
        defer {
            OSSpinLockUnlock(&shared.operationsLock)
        }
        for (idx, obj) in shared.operations.enumerated() {
            if obj.path == file.path {
                shared.operations.remove(at: idx)
                break
            }
        }
    }
    
    // MARK: Callback
    
    private var callbacks = [Int: FileThumbnailCallback]()
    private var callbacksLock: OSSpinLock = OS_SPINLOCK_INIT
    
    private class func appendCallback(hash: Int, file: File, block: FileThumbnailBlock!) {
        guard block != nil else {
            return
        }
        OSSpinLockLock(&shared.callbacksLock)
        defer {
            OSSpinLockUnlock(&shared.callbacksLock)
        }
        shared.callbacks[hash] = FileThumbnailCallback(file: file, block: block)
    }
    
    private class func callback(file: File, image: UIImage!) {
        OSSpinLockLock(&shared.callbacksLock)
        defer {
            OSSpinLockUnlock(&shared.callbacksLock)
        }
        let callbacks = shared.callbacks
        for (idx, callback) in callbacks {
            if callback.file == file {
                shared.callbacks.removeValue(forKey: idx)
                if image != nil {
                    FileThumbnailQueue.addOperation({ 
                        callback.block(file, image)
                    })
                }
            }
        }
    }
    
}







func fileThumbnail(file: File, block: @escaping FileThumbnailBlock) {
//    guard !Thread.isMainThread else {
//        OperationQueue().addOperation({
//            fileThumbnail(file: file, block: block)
//        })
//        return
//    }
    
    let image: UIImage?
    
    switch file.type {
    case .Directory:
        image = UIImage(named: "icon_directory")
    case .Audio:
//        if let cover = MusicModel.cover(for: file.url) {
//            image = cover
//        }
//        else {
            image = UIImage(named: "icon_audio")
//        }
    case .Video:
        image = UIImage(named: "icon_video")
    case .Zip:
        image = UIImage(named: "icon_zip")
    case .Photo:
//        image = UIImage(contentsOfFile: file.path)?.decode()
        ImageCache.share.fileIcon(url: file.url, completionBlock: { (url, image) in
            block(file, image)
        })
        return
    default:
        image = UIImage(named: "icon_unknown")
    }
    
    guard image != nil else {
        return
    }

//    OperationQueue.main.addOperation { 
        block(file, image!.decode())
//    }
    
}

