//
//  ThumbnailCache.swift
//  file
//
//  Created by 翟泉 on 2016/6/29.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class ThumbnailCache: Cache<NSString, UIImage>, CacheDelegate {
    
    static let sharedInstance = ThumbnailCache()
    
    private override init() {
        super.init()
        name = NSStringFromClass(classForCoder)
        countLimit = 60
        NotificationCenter.default().addObserver(self, selector: #selector(ThumbnailCache.didReceiveMemoryWarning), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    func didReceiveMemoryWarning() {
        removeAllObjects()
    }
    
    typealias ThumbnailCallback = (path: String, thumbnail: UIImage) -> Void
    
    let operationQueue = OperationQueue()
    
    
    func thumbnail(imagePath path:String, width: CGFloat, callback: ThumbnailCallback) {
        guard path != "" && width > 0 else {
            return
        }
        
        
        if let thumbnail = object(forKey: path) {
            callback(path: path, thumbnail: thumbnail)
            return
        }
        
        let cachePath = cacheDirectory + "/\(Int(width * UIScreen.main().scale))_\(path.hashValue)"
        if let thumbnail = UIImage(contentsOfFile: cachePath) {
            callback(path: path, thumbnail: thumbnail)
            setObject(thumbnail, forKey: path)
        }
        else {
            operationQueue.addOperation({
                guard let image = UIImage(contentsOfFile: DocumentDirectory() + "/" + path) else {
                    return
                }
                
                let thumbnail = image.scale(newWidth: width * UIScreen.main().scale).square()
                OperationQueue.main().addOperation({ 
                    callback(path: path, thumbnail: thumbnail)
                })
                self.setObject(thumbnail, forKey: path)
                if let thumbnailData = UIImagePNGRepresentation(thumbnail) {
                    do {
//                        Data.WritingOptions.atomicWrite
                        try thumbnailData.write(to: URL(fileURLWithPath: cachePath))
                    }
                    catch {
                        
                    }
                }
            })
        }
        
    }
    
    
    
    lazy var cacheDirectory: String = {
        let value = DocumentDirectory() + "/ThumbnailCache"
        var isDirectory: ObjCBool = false
        FileManager.default().fileExists(atPath: value, isDirectory: &isDirectory)
        if !isDirectory {
            do {
                try FileManager.default().createDirectory(atPath: value, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
            }
        }
        return value
    }()
    
}
