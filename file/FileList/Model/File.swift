//
//  File.swift
//  file
//
//  Created by 翟泉 on 16/4/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

struct File {
    
    let path: String
    
    // 相对路径
    let relativePath: String
    
    let type: FileType
    
    // 属性
    let attributes: [String : AnyObject]
    
    let size: UInt64
    
    let creationDate: NSDate
    
    let modificationDate: NSDate
    
    init(path: String) {
        self.path = path
        
        var tempPath = path
        tempPath.removeRange(path.rangeOfString(DocumentDirectory())!)
        relativePath = tempPath
        
        var flag: ObjCBool = false
        NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &flag)
        if flag.boolValue {
            self.type = FileType.Directory
        }
        else {
            self.type = FileType(ext: NSString(string: path).pathExtension)
        }
        
        
        do {
            attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(self.path)
            
            if let object = attributes[NSFileSize] as? NSNumber {
                size = object.unsignedLongLongValue
            }
            else {
                size = 0
            }
            
            if let object = attributes[NSFileCreationDate] as? NSDate {
                creationDate = object
            }
            else {
                creationDate = NSDate(timeIntervalSince1970: 0)
            }
            
            if let object = attributes[NSFileModificationDate] as? NSDate {
                modificationDate = object
            }
            else {
                modificationDate = NSDate(timeIntervalSince1970: 0)
            }
        }
        catch {
            attributes = [:]
            size = 0
            creationDate = NSDate(timeIntervalSince1970: 0)
            modificationDate = NSDate(timeIntervalSince1970: 0)
        }
    }
    
    
    var pathExtension: String {
        return NSString(string: path).pathExtension
    }
    
    var lastPathComponent: String {
        return NSString(string: path).lastPathComponent
    }
    
}

extension File: Hashable {
    var hashValue: Int {
        return relativePath.hashValue
    }
}

extension File: CustomStringConvertible {
    var description: String {
        var description = type.description
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        description += "\t" + dateFormatter.stringFromDate(modificationDate)
        
        if type == FileType.Directory {
            return description
        }
        
        
        let ext = ["B", "KB", "MB", "GB"]
        var s = Double(size)
        var ssize = ""
        for i in 0 ..< ext.count {
            if s < 1000 || i == ext.count-1 {
                
                
                ssize = String(format: "%.2lf", s) + ext[i]
                
                
                break
            }
            s /= 1000.0
        }
        description += "\t" + ssize
        
        return description
    }
}

extension File: Equatable {
    
}

func ==(lhs: File, rhs: File) -> Bool {
    return lhs.path == rhs.path
}

//extension File: StringLiteralConvertible {
//    
//    
//}
