//
//  UIImage.swift
//  file
//
//  Created by 翟泉 on 16/4/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     根据指定宽度等比缩放图片
     
     - parameter newWidth: 新的图片宽度
     
     - returns: 返回结果图片对象
     */
    func scale(newWidth: CGFloat) -> UIImage {
        
        let newSize = CGSize(width: newWidth, height: newWidth / size.width * size.height)
        UIGraphicsBeginImageContext(newSize)
        drawInRect(CGRect(origin: CGPoint(x: 0,y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     缩略图
     
     - returns: 返回结果图片对象
     */
    func thumbnail() -> UIImage {
        return scale(150)
    }
    
    
    /**
     居中裁剪一块最大的方形
     
     - returns: 返回结果图片对象
     */
    func square() -> UIImage {
        
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

