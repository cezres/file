//
//  Extension.swift
//  file
//
//  Created by 翟泉 on 16/5/19.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     相对于父视图居中
     */
    func photo_centeringForSuperview() {
        guard superview != nil else {
            return
        }
        guard frame.size != CGSizeZero else {
            return
        }
        let height = superview!.frame.width * frame.height / frame.width
        if height < superview!.frame.size.height {
            self.frame = CGRectMake(0, (superview!.frame.height - height) / 2, superview!.frame.width, height)
        }
        else {
            let widht = superview!.frame.height * frame.width / frame.height
            self.frame = CGRectMake((superview!.frame.width - widht) / 2, 0, widht, superview!.frame.height)
        }
    }
    
}

extension UIImage {
    
    
    func photo_scale(newWidth: CGFloat) -> UIImage {
        
        let newSize = CGSize(width: newWidth, height: newWidth / size.width * size.height)
        UIGraphicsBeginImageContext(newSize)
        drawInRect(CGRect(origin: CGPoint(x: 0,y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func photo_thumbnail() -> UIImage {
        if self.size.width <= 200 {
            return self
        }
        return photo_scale(200)
    }
    
}


extension String {
    
    var photo_lastPathComponent: String {
        get {
            return NSString(string: self).lastPathComponent
        }
    }
    
}
