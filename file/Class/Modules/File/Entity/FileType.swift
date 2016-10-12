//
//  FileType.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

/**
 * 文件类型
 */
enum FileType {
    case Directory  // 目录
    case Photo      // 图片
    case Video      // 视频
    case Audio      // 音频
    case Zip        // 压缩文件
    case Unknown    // 未知
    
    /**
     初始化
     
     - parameter path: 文件路径
     
     - returns: 文件类型
     */
    init(path: String) {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        
        guard !isDirectory.boolValue else {
            self = .Directory
            return
        }
        
        switch path.pathExtension.lowercased() {
        case "png", "jpg", "jpeg", "nef":
            self = .Photo
        case "flv", "mp4", "avi":
            self = .Video
        case "mp3", "wav":
            self = .Audio
        case "zip":
            self = .Zip
        default:
            self = .Unknown
        }
    }
    
    func value() -> Int {
        switch self {
        case .Directory:
            return 0
        case .Photo:
            return 1
        case .Video:
            return 2
        case .Audio:
            return 3
        case .Zip:
            return 4
        case .Unknown:
            return 5
        }
    }
    
}


extension FileType: CustomStringConvertible {
    var description: String {
        switch self {
        case .Photo:
            return "图片"
        case .Video:
            return "视频"
        case .Audio:
            return "音频"
        case .Directory:
            return "目录"
        case .Zip:
            return "压缩包"
        default:
            return "未知"
        }
    }
}


func ==(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.value() == rhs.value()
}

func <(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.value() < rhs.value()
}

func <=(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.value() <= rhs.value()
}

func >=(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.value() >= rhs.value()
}

func >(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.value() > rhs.value()
}


extension FileType: Comparable {
    
}
