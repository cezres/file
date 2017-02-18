//
//  Macro.swift
//  file
//
//  Created by 翟泉 on 2016/9/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import UIKit


let SSize = UIScreen.main.bounds.size

// MARK: - Path

let HomeDirectory = NSHomeDirectory()

let DocumentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

//let DocumentDirectory = "/Users/cezr"
//let CachesDirectory = "/Users/cezr/Documents"

let CachesDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]


// MARK: - Color
func ColorWhite(_ white: CGFloat)  -> UIColor {
    return ColorWhiteAlpha(white, 1.0)
}

func ColorWhiteAlpha(_ white: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor(white: white/255.0, alpha: alpha)
}

func ColorRGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return ColorRGBA(r, g, b, 1.0)
}

func ColorRGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

// MARK: - Font
func Font(_ size: CGFloat) -> UIFont {
    return UIFont(name: "ArialMT", size: size)!
}

