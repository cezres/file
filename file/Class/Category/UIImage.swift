//
//  UIImage.swift
//  file
//
//  Created by 翟泉 on 2016/6/29.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scale(newWidth: CGFloat) -> UIImage {
        let newSize = CGSize(width: newWidth, height: newWidth / size.width * size.height)
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: CGPoint(x: 0,y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
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
        if let imageRef = self.cgImage!.cropping(to: rect) {
            return UIImage(cgImage: imageRef)
        }
        return self
    }
    
}
