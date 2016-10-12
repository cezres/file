//
//  UIView+Frame.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


extension UIView {
    
    // MARK: - origin
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame = CGRect(origin: newValue, size: size)
        }
    }
    
    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin = CGPoint(x: newValue, y: y)
        }
    }
    
    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin = CGPoint(x: x, y: newValue)
        }
    }
    
    
    // MARK: - Size
    
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame = CGRect(origin: origin, size: newValue)
        }
    }
    
    var width: CGFloat {
        get {
            return size.width
        }
        set {
            size = CGSize(width: newValue, height: height)
        }
    }
    
    var height: CGFloat {
        get {
            return size.height
        }
        set {
            size = CGSize(width: width, height: newValue)
        }
    }
    
}
