//
//  Const.swift
//  file
//
//  Created by 翟泉 on 16/4/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import UIKit




func CachesDirectory() -> String {
    if TARGET_IPHONE_SIMULATOR > 0 {
        return "/Users/cezr/Documents/FILECACHES"
    }
    else {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
}

func DocumentDirectory() -> String {
    if TARGET_IPHONE_SIMULATOR > 0 {
        return "/Users/cezr/Documents"
    }
    else {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
}


func Font(size: CGFloat) -> UIFont {
    return UIFont(name: "ArialMT", size: size)!
}




