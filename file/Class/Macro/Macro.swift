//
//  Macro.swift
//  file
//
//  Created by cezr on 16/6/23.
//  Copyright © 2016年 cezr. All rights reserved.
//

import Foundation



func DocumentDirectory() -> String {
//    if TARGET_IPHONE_SIMULATOR > 0 {
//        return "/Users/cezr/Documents"
//    }
//    else {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//    }
}

