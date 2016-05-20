//
//  FileType.swift
//  file
//
//  Created by 翟泉 on 16/4/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

enum FileType: CustomStringConvertible {
    case Directory
    case Photo
    case Video
    case Audio
    case Unknown
    
    init(ext: String) {
        switch ext {
        case "png", "jpg", "jpeg", "NEF":
            self = .Photo
        case "flv", "mp4":
            self = .Video
        case "mp3", "wav":
            self = .Audio
        default:
            self = .Unknown
        }
    }
    
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
        default:
            return "未知"
        }
    }
    
    var iconName: String {
        switch self {
        case .Video:
            return "Video"
        case .Audio:
            return "Audio"
        case .Directory:
            return "Directory"
        default:
            return "Unknown"
        }
    }
    
    var intValue: Int {
        switch self {
        case .Photo:
            return 1
        case .Video:
            return 2
        case .Audio:
            return 3
        case .Directory:
            return 0
        default:
            return 4
        }
    }
}


func >(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.intValue > rhs.intValue
}

func <(lhs: FileType, rhs: FileType) -> Bool {
    return lhs.intValue < rhs.intValue
}

