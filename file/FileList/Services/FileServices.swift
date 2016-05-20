//
//  FileServices.swift
//  file
//
//  Created by 翟泉 on 16/5/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileServices {

    /**
     遍历目录
     
     - parameter directoryPath: 目录路径
     - parameter subDirectory:  遍历子目录
     - parameter callback:      回调
     */
    class func traverseDirectory(directoryPath: String, subDirectory: Bool = false, callback: (file: File)->Void ) {
        
        do {
            let filenames = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(directoryPath)
            for filename in filenames {
                let path = directoryPath + "/" + filename
                let file = File(path: path)
                
                callback(file: file)
                
                if subDirectory && file.type == .Directory {
                    traverseDirectory(path, subDirectory: subDirectory, callback: callback)
                }
            }
        }
        catch {
            print(error)
        }
        
    }
    
    /**
     新建文件夹
     
     - parameter directoryPath: 文件夹路径
     
     - returns: <#return value description#>
     */
    class func createDirectory(directoryPath: String) -> Bool {
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil)
            return true
        }
        catch {
            return false
        }
    }
    
    /**
     删除文件
     
     - parameter path: 文件路径
     
     - returns: <#return value description#>
     */
    class func removeFile(path: String) -> Bool {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
            return true
        }
        catch {
            return false
        }
    }
    
    /**
     移动文件
     
     - parameter srcPath: <#srcPath description#>
     - parameter toPath:  <#toPath description#>
     
     - returns: <#return value description#>
     */
    class func moveFile(srcPath: String, toPath: String) -> Bool {
        do {
            var _toPath = toPath
            while NSFileManager.defaultManager().fileExistsAtPath(_toPath) {
                if let range = _toPath.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) {
                    _toPath = _toPath.stringByReplacingCharactersInRange(range, withString: "/0")
                }
                else {
                    return false
                }
            }
            try NSFileManager.defaultManager().moveItemAtPath(srcPath, toPath: _toPath)
            return true
        }
        catch {
            return false
        }
    }
    
    /**
     拷贝文件
     
     - parameter srcPath: <#srcPath description#>
     - parameter toPath:  <#toPath description#>
     
     - returns: <#return value description#>
     */
    class func copyFile(srcPath: String, toPath: String) -> Bool {
        do {
            var _toPath = toPath
            while NSFileManager.defaultManager().fileExistsAtPath(_toPath) {
                if let range = _toPath.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) {
                    _toPath = _toPath.stringByReplacingCharactersInRange(range, withString: "/0")
                }
                else {
                    return false
                }
            }
            try NSFileManager.defaultManager().copyItemAtPath(srcPath, toPath: _toPath)
            return true
        }
        catch {
            return false
        }
    }
    
}
