//
//  FileThumbnail.swift
//  file
//
//  Created by 翟泉 on 2016/9/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import PINCache
import ESMediaPlayer
import FastImageCache




private let ImageFormatFamily = "ImageFormatFamily"
private let FileIconCacheFormatName = "FileIconCacheFormatName"



typealias FileThumbnailBlock = (_ file: File, _ image: UIImage) -> Void

class FileThumbnail: NSObject, FICImageCacheDelegate {
    
    static let shared = FileThumbnail()
    
//    var cache: PINCache!
    let imageCache: FICImageCache = FICImageCache.shared()
//    var diskCache: PINDiskCache!
    
    let operationQueue = OperationQueue()
    
    private override init() {
        super.init()
        
        operationQueue.maxConcurrentOperationCount = 6
        
        imageCache.delegate = self
        
        let fileImageFormat = FICImageFormat(name: FileIconCacheFormatName, family: ImageFormatFamily, imageSize: CGSize(width: 128, height: 128), style: .style32BitBGR, maximumCount: 200, devices: .phone, protectionMode: .none)!
        imageCache.setFormats([fileImageFormat])
        
        /*
        let operationQueue = PINOperationQueue(maxConcurrentOperations: 10)
        diskCache = PINDiskCache(name: "FileThumbnail", rootPath: "", serializer: { (coding, key) -> Data in
            guard let image = coding as? UIImage else {
                return Data()
            }
            return UIImagePNGRepresentation(image)!
        }, deserializer: { (data, key) -> NSCoding in
            return UIImage(data: data)!
        }, fileExtension: nil, operationQueue: operationQueue)
        
        diskCache.byteLimit = UInt(1024 * 1024 * 100)*/
        
    }
    
    func thumbnail(file: File, callback: @escaping FileThumbnailBlock) {
        let fileIconEntity = FileIconEntity(file: file)
        let completionBlock: FICImageCacheCompletionBlock = { (entity, _, image) in
            guard let iconEntity = entity as? FileIconEntity else { return }
            if Thread.isMainThread {
                callback(iconEntity.file, image!)
            }
            else {
                OperationQueue.main.addOperation({ 
                    callback(iconEntity.file, image!)
                })
            }
        }
        
        if imageCache.imageExists(for: fileIconEntity, withFormatName: FileIconCacheFormatName) {
            imageCache.retrieveImage(for: fileIconEntity, withFormatName: FileIconCacheFormatName, completionBlock: completionBlock)
        }
        else {
            operationQueue.addOperation {
                self.imageCache.retrieveImage(for: fileIconEntity, withFormatName: FileIconCacheFormatName, completionBlock: completionBlock)
            }
        }
    }
    
    // MARK: FICImageCacheDelegate
    func imageCache(_ imageCache: FICImageCache!, errorDidOccurWithMessage errorMessage: String!) {
        print(#function)
    }
    func imageCache(_ imageCache: FICImageCache!, cancelImageLoadingFor entity: FICEntity!, withFormatName formatName: String!) {
        print(#function)
    }
    func imageCache(_ imageCache: FICImageCache!, shouldProcessAllFormatsInFamily formatFamily: String!, for entity: FICEntity!) -> Bool {
        print(#function)
        return false
    }
    @nonobjc internal func imageCache(_ imageCache: FICImageCache!, wantsSourceImageFor entity: FileIconEntity!, withFormatName formatName: String!, completionBlock: FICImageRequestCompletionBlock!) {
        print(#function)
        
        OperationQueue().addOperation {
            let file: File = entity.file
            
            var image: UIImage?
            switch file.type {
            case .Directory:
                image = UIImage(named: "icon_directory")
            case .Audio:
                image = UIImage(named: "icon_audio")
            case .Video:
                image = ESMediaPlayerView.thumbnailImage(with: file.url, atTime: 2) ?? UIImage(named: "icon_video")
            case .Photo:
                image = UIImage(contentsOfFile: file.url.path)?.square()
            case .Zip:
                image = UIImage(named: "icon_zip")
            default:
                image = UIImage(named: "icon_unknown")
            }
            completionBlock(image)
        }
    }
}



























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





