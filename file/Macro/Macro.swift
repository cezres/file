//
//  Macro.swift
//  file
//
//  Created by 翟泉 on 16/5/12.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import UIKit


// MARK: Size

let SSize = UIScreen.mainScreen().bounds.size

// MARK: Path

func CachesDirectory() -> String {
//    #if TARGET_IPHONE_SIMULATOR
//        return "/Users/cezr/Documents/FILECACHES"
//    #else
//        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
//    #endif
    if TARGET_IPHONE_SIMULATOR > 0 {
        return "/Users/cezr/Documents/FILECACHES"
    }
    else {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
}

func DocumentDirectory() -> String {
//    TARGET_IPHONE_SIMULATOR
    
//    #if TARGET_IPHONE_SIMULATOR == 0
//        return "/Users/cezr/Documents"
//    #else
//        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)[0]
//    #endif
    
    if TARGET_IPHONE_SIMULATOR > 0 {
        return "/Users/cezr/Documents"
    }
    else {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
}

// MARK: Font

func Font(size: CGFloat) -> UIFont {
    return UIFont(name: "ArialMT", size: size)!
}

// MARK: Color

func ColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return ColorRGBA(r, g: g, b: b, a: 1)
}

func ColorRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}