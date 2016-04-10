//
//  Extension.swift
//  ESPhotoViewer
//
//  Created by 翟泉 on 16/4/5.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit


extension UIView {
    
    func es_centeringForSuperview() {
        
        guard superview != nil else {
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
    
    func es_scale(newWidth: CGFloat) -> UIImage {
        
        let newSize = CGSize(width: newWidth, height: newWidth / size.width * size.height)
        UIGraphicsBeginImageContext(newSize)
        drawInRect(CGRect(origin: CGPoint(x: 0,y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func es_thumbnail() -> UIImage {
        return es_scale(90)
    }
    
    func es_square() -> UIImage {
        
        let rect: CGRect
        if size.width > size.height {
            rect = CGRect(x: (size.width-size.height)/2, y: 0, width: size.height, height: size.height)
        }
        else if size.width < size.height {
            rect = CGRect(x: 0, y: (size.height-size.width)/2, width: size.width, height: size.width)
        }
        else {
            return self
        }
        if let imageRef = CGImageCreateWithImageInRect(self.CGImage, rect) {
            return UIImage(CGImage: imageRef)
        }
        return self
    }
}
