//
//  File.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation

class File {
    
    let path: String
    let name: String
    let type: FileType
    let attributes: FileAttributes
    let url: URL
    
    
    /**
     初始化
     - parameter path: 文件路径
     */
    init(path: String) {
        self.path = path
        
        url = URL(fileURLWithPath: path)
        name = path.lastPathComponent
        
        type = FileType(path: path)
        attributes = FileAttributes(path: path)
        
        /*
        do {
            print(try FileManager.default.attributesOfItem(atPath: path))
        }
        catch {
            print(#file, #function, #line)
        }*/
    }
    
    /// 相对路径
    lazy var relativePath: String = {
        return self.path.relativePath
    }()
    
    /// 路径后缀
    lazy var `extension`: String = {
        return self.path.pathExtension
    }()
    
}


func ==(lhs: File, rhs: File) -> Bool {
    return lhs.path == rhs.path
}

extension File: Equatable {
    
}



extension File: Hashable {
    var hashValue: Int {
        return path.hashValue
    }
}



