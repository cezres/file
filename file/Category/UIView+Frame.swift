//
//  UIView+Frame.swift
//  file
//
//  Created by 翟泉 on 16/5/12.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
    }
    
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
    }
    
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
    }
    
}
