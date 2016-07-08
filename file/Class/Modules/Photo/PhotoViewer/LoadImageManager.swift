//
//  LoadImageManager.swift
//  file
//
//  Created by 翟泉 on 2016/6/30.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


func thumbnail(image: UIImage) -> UIImage? {
    let maxSize = CGSize(width: UIScreen.main().bounds.width * UIScreen.main().scale * 0.8, height: UIScreen.main().bounds.height * UIScreen.main().scale * 0.8)
    if image.size.width <= maxSize.width && image.size.height <= maxSize.height {
        return nil
    }
    
    let drawableSize: CGSize
    let height = maxSize.width * image.size.height / image.size.width
    if height < maxSize.height {
        drawableSize = CGSize(width: maxSize.width, height: height)
    }
    else {
        let width = maxSize.height * image.size.width / image.size.height
        drawableSize = CGSize(width: width, height: maxSize.height)
    }
    
    UIGraphicsBeginImageContext(drawableSize)
    image.draw(in: CGRect(x: 0, y: 0, width: drawableSize.width, height: drawableSize.height))
    let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return thumbnail
}

class LoadImageManager {

    typealias LoadImageCallback = (path: NSString, image: UIImage) -> Void
    
    struct LoadImageTask {
        let path: String
        let callback: LoadImageCallback
    }
    
    struct OriginalImageCallbackTask {
        let path: String
        let callback: LoadImageCallback
        let originalImage: UIImage
        
        func imageCallback() {
            callback(path: path, image: originalImage)
        }
    }
    
    static let manager = LoadImageManager()
    
    let operationQueue = OperationQueue()
    
    let imageCache = Cache<NSString, UIImage>()
    
    let thumbnailCache = Cache<NSString, UIImage>()
    
    var loadImageTasks = [LoadImageTask]()
    
    var originalImageCallbackTasks = [OriginalImageCallbackTask]()
    
    let runLoop: CFRunLoop
    var observer: CFRunLoopObserver!
    var taskSpinLock: OSSpinLock = OS_SPINLOCK_INIT
    var runLoopSpinLock: OSSpinLock = OS_SPINLOCK_INIT
    
    private init() {
        runLoop = CFRunLoopGetMain()
        observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, 1 << 5, true, 0, { (_, _) in
            self.runLoopObserverHandle()
        })
        imageCache.countLimit = 6
        thumbnailCache.countLimit = 12
        NotificationCenter.default().addObserver(self, selector: #selector(LoadImageManager.didReceiveMemoryWarning), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    @objc func didReceiveMemoryWarning() {
        thumbnailCache.removeAllObjects()
        imageCache.removeAllObjects()
    }
    
    
    func loadImage(imagePath path: String, callback: LoadImageCallback) {
        if let image = imageCache.object(forKey: path) {
            callback(path: path, image: image)
        }
        else if let thumbnail = thumbnailCache.object(forKey: path) {
            callback(path: path, image: thumbnail)
            addOriginalImageCallbackTask(originalImage: nil, path: path, callback: callback)
        }
        else {
            addLoadImageTask(imagePath: path, callback: callback)
        }
    }
    
    
    func addLoadImageTask(imagePath path: String, callback: LoadImageCallback) {
        for task in loadImageTasks {
            if task.path == path {
                loadImageTasks.append(LoadImageTask(path: path, callback: callback))
                return
            }
        }
        loadImageTasks.append(LoadImageTask(path: path, callback: callback))
        
        operationQueue.addOperation {
            
            func imageCallback(image: UIImage?) {
                OperationQueue.main().addOperation({
                    let tasks = self.loadImageTasks
                    for (idx, task) in tasks.enumerated() {
                        if task.path == path {
                            let index = idx - (tasks.count - self.loadImageTasks.count)
                            self.loadImageTasks.remove(at: index)
                            if image != nil {
                                task.callback(path: task.path, image: image!)
                            }
                        }
                    }
                })
            }
            
            guard let image = UIImage(contentsOfFile: path) else {
                imageCallback(image: nil)
                return
            }
            
            
            if let thumbnail = thumbnail(image: image) {
                if CFRunLoopCopyCurrentMode(self.runLoop).rawValue == CFRunLoopMode.commonModes.rawValue {
                    imageCallback(image: image)
                }
                else {
                    imageCallback(image: thumbnail)
                }
                self.thumbnailCache.setObject(thumbnail, forKey: path)
            }
            else {
                self.imageCache.setObject(image, forKey: path)
                imageCallback(image: image)
            }
            
            
        }
    }
    
    func addOriginalImageCallbackTask(originalImage: UIImage?, path: String, callback: LoadImageCallback) {
        if originalImage == nil {
            operationQueue.addOperation({ 
                if let originalImage = UIImage(contentsOfFile: path) {
                    OSSpinLockLock(&self.taskSpinLock)
                    self.originalImageCallbackTasks.append(OriginalImageCallbackTask(path: path, callback: callback, originalImage: originalImage))
                    OSSpinLockUnlock(&self.taskSpinLock)
                    self.startRunLoopObserver()
                }
            })
        }
        else {
            OSSpinLockLock(&self.taskSpinLock)
            originalImageCallbackTasks.append(OriginalImageCallbackTask(path: path, callback: callback, originalImage: originalImage!))
            OSSpinLockUnlock(&self.taskSpinLock)
            startRunLoopObserver()
        }
    }
    
    func startRunLoopObserver() {
        OSSpinLockLock(&runLoopSpinLock)
        if !CFRunLoopContainsObserver(runLoop, observer, CFRunLoopMode.defaultMode) {
            print("Add")
            CFRunLoopAddObserver(runLoop, observer, CFRunLoopMode.defaultMode)
        }
        OSSpinLockUnlock(&runLoopSpinLock)
    }
    
    func runLoopObserverHandle() {
        OSSpinLockLock(&taskSpinLock)
        let tasks = originalImageCallbackTasks
        originalImageCallbackTasks.removeAll()
        OSSpinLockUnlock(&taskSpinLock)
        for task in tasks {
            task.imageCallback()
        }
        if originalImageCallbackTasks.count == 0 {
            print("Remove")
            OSSpinLockLock(&runLoopSpinLock)
            CFRunLoopRemoveObserver(runLoop, observer, CFRunLoopMode.defaultMode)
            OSSpinLockUnlock(&runLoopSpinLock)
        }
    }
    
    
    
    
}



