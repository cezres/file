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
    
    let type: FileType
    
    init(path: String) {
        self.path = path
        
        var flag: ObjCBool = false
        NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &flag)
        if flag.boolValue {
            self.type = FileType.Directory
        }
        else {
            self.type = FileType(ext: NSString(string: path).pathExtension)
        }
    }
    
    var pathExtension: String {
        return NSString(string: path).pathExtension
    }
    
    var lastPathComponent: String {
        return NSString(string: path).lastPathComponent
    }
    
    // 相对路径
    var relativePath: String {
        var relativePath = path
        relativePath.removeRange(path.rangeOfString(DocumentDirectory())!)
        return relativePath
    }
    
}

extension File: Hashable {
    var hashValue: Int {
        return path.hashValue
    }
}

extension File: CustomStringConvertible {
    var description: String {
        
        return lastPathComponent + "\t" + type.description
    }
}

extension File: Equatable {
    
}

func ==(lhs: File, rhs: File) -> Bool {
    return lhs.path == rhs.path
}
