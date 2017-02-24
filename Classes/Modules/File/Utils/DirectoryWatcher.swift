//
//  DirectoryWatcher.swift
//  file
//
//  Created by 翟泉 on 2017/2/24.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit

/*

protocol DirectoryWatcherDelegate: NSObjectProtocol {
    func directoryDidChange(folderWatcher: DirectoryWatcher)
}

class DirectoryWatcher {
    
    let delegate: DirectoryWatcherDelegate
    
    init(watchPath: String, delegate: DirectoryWatcherDelegate) {
        self.delegate = delegate
        
        dirFD = -1
        kq = -1
        dirKQ = nil
        
        let result = startMonitoringDirectory(dirPath: watchPath)
        assert(result)
    }
    
    func invalidate() {
        if dirKQ != nil {
            CFFileDescriptorInvalidate(dirKQ!)
            kq = 1
        }
        if dirFD != -1 {
            close(dirFD)
            dirFD = -1
        }
    }
    
    private var dirKQ: CFFileDescriptor?
    private var dirFD: Int32 = 0
    private var kq: Int32 = 0
    
    fileprivate func kqueueFired() {
        assert(kq >= 0)
        var event = kevent()
        var timeout = timespec(tv_sec: 0, tv_nsec: 0)
        
        let eventCount = kevent(kq, nil, 0, &event, 1, &timeout)
        assert(eventCount >= 0 && eventCount < 2)
        
        delegate.directoryDidChange(folderWatcher: self)
        
        CFFileDescriptorEnableCallBacks(dirKQ, kCFFileDescriptorReadCallBack)
    }
    
    private func startMonitoringDirectory(dirPath: String) -> Bool {
        if dirKQ != nil || dirFD != -1 || kq != -1 {
            return false
        }
        
        let path = (dirPath as NSString).fileSystemRepresentation
        dirFD = open(path, O_EVTONLY)
        if dirFD < 0 {
            return false
        }
        defer {
            close(dirFD)
            dirFD = -1
        }
        
        kq = kqueue()
        if kq < 0 {
            return false
        }
        var eventToAdd = kevent()
        eventToAdd.ident = UInt(dirFD)
        eventToAdd.filter = Int16(EVFILT_VNODE)
        eventToAdd.flags = UInt16(EV_ADD) | UInt16(EV_CLEAR)
        eventToAdd.fflags = UInt32(NOTE_WRITE)
        eventToAdd.data = 0
        eventToAdd.udata = nil
        
        let errNum = kevent(kq, &eventToAdd, 1, nil, 0, nil)
        if errNum != 0 {
            return false
        }
        
        let objPointer = UnsafeMutablePointer<DirectoryWatcher>.allocate(capacity: 1)
        objPointer.pointee = self
        let info = UnsafeMutableRawPointer(objPointer)
        
        var context = CFFileDescriptorContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
        
//        CFFileDescriptorCallBack
        dirKQ = CFFileDescriptorCreate(nil, kq, true, KQCallback, &context)
        if dirKQ == nil {
            return false
        }
        defer {
            CFFileDescriptorInvalidate(dirKQ!)
            dirKQ = nil
        }
        
        let rls = CFFileDescriptorCreateRunLoopSource(nil, dirKQ!, 0)
        if rls == nil {
            return false
        }
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, CFRunLoopMode.defaultMode)
        CFFileDescriptorEnableCallBacks(dirKQ!, kCFFileDescriptorReadCallBack)
        return true
    }
    

}

func KQCallback(f: CFFileDescriptor?, callBackTypes: CFOptionFlags, info: UnsafeMutableRawPointer?) -> Void {
    guard let info = info else {
        return
    }
    let opaquePtr = OpaquePointer(info)
    let contextPtr = UnsafeMutablePointer<DirectoryWatcher>(opaquePtr)
    let obj = contextPtr.pointee
    obj.kqueueFired()
}*/
