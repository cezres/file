//
//  SettingServices.swift
//  file
//
//  Created by 翟泉 on 16/5/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

enum FilelistDisplayMode: Int {
    case TableView      = 0
    case CollectionView = 1
//    case Photo = 2
}

extension FilelistDisplayMode: CustomStringConvertible {
    var description: String {
        switch self {
        case .TableView:
            return "列表"
        case .CollectionView:
            return "图标"
//        case .Photo:
//            return "照片"
        }
    }
}




class SettingServices {
    
    var filelistDisplayMode = FilelistDisplayMode.TableView
    
    static let sharedInstance = SettingServices()
    
    
    init() {
        read()
    }
    
}

extension SettingServices {
    
    func save() {
        NSUserDefaults.standardUserDefaults().setInteger(filelistDisplayMode.rawValue, forKey: "FilelistDisplayMode")
    }
    
    func read() {
        filelistDisplayMode = FilelistDisplayMode(rawValue: NSUserDefaults.standardUserDefaults().integerForKey("FilelistDisplayMode")) ?? .TableView
    }
    
}
