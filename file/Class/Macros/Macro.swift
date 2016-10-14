//
//  Macro.swift
//  file
//
//  Created by 翟泉 on 2016/9/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Path

let HomeDirectory = NSHomeDirectory()

let DocumentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

let CachesDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]


// MARK: - Color
func ColorWhite(white: CGFloat)  -> UIColor {
    return ColorWhiteAlpha(white: white, alpha: 1.0)
}

func ColorWhiteAlpha(white: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(white: white/255.0, alpha: alpha)
}

func ColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return ColorRGBA(r: r, g: g, b: b, a: 1.0)
}

func ColorRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

// MARK: - Font
func Font(_ size: CGFloat) -> UIFont {
    return UIFont(name: "ArialMT", size: size)!
}

