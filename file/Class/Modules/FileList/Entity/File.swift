//
//  File.swift
//  file
//
//  Created by 翟泉 on 2016/6/28.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

enum FileType {
    case Directory
    case Photo
    case Video
    case Audio
    case Zip
    case Unknown
    
    init(ext: String) {
        switch ext {
        case "png", "jpg", "jpeg", "NEF":
            self = .Photo
        case "flv", "mp4":
            self = .Video
        case "mp3", "wav":
            self = .Audio
        case "zip":
            self = .Zip
        default:
            self = .Unknown
        }
    }
    
    var intValue: Int {
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
        default:
            return 5
        }
    }
    
}

func >(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.intValue > rhs.intValue
}

func <(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.intValue < rhs.intValue
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

struct FileEntity {
    
    let path: String
    let absPath: String
    let name: String
    let type: FileType
    let attributes: [String : AnyObject]
    let pathExtension: String
    
    init(path: String) {
        absPath = path
        
        let nstr: NSString = NSString(string: absPath)
        name = nstr.lastPathComponent
        pathExtension = nstr.pathExtension
        
        self.path = nstr.substring(from: nstr.range(of: DocumentDirectory()).length)
        
        
        var isDirectory: ObjCBool = false
        FileManager.default().fileExists(atPath: absPath, isDirectory: &isDirectory)
        if isDirectory {
            type = FileType.Directory
        }
        else {
            type = FileType(ext: pathExtension)
        }
        
        do {
            attributes = try FileManager.default().attributesOfItem(atPath: absPath)
        }
        catch {
            attributes = [:]
        }
        
    }
}




