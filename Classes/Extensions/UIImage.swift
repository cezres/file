//
//  UIImage.swift
//  file
//
//  Created by 翟泉 on 2016/9/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


extension UIImage {
    
    /**
     等比缩放
     
     - parameter newWidth: 新的宽度
     
     - returns: <#return value description#>
     */
    func scale(newWidth: CGFloat) -> UIImage {
        let newSize = CGSize(width: newWidth, height: newWidth / size.width * size.height)
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: CGPoint(x: 0,y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     居中截取一个最大的正方形
     
     - returns: <#return value description#>
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
        
        if let imageRef = cgImage!.cropping(to: rect) {
            return UIImage(cgImage: imageRef)
        }
        return self
    }
    
    /**
     解码
     
     - returns: <#return value description#>
     */
    func decode() -> UIImage {
        guard images == nil else {
            return self
        }
        
        
        guard let imageRef = cgImage else {
            return self
        }
        
        let alpha = imageRef.alphaInfo
        
        guard alpha != .first && alpha != .last && alpha != .premultipliedFirst && alpha != .premultipliedLast else {
            return self
        }
        
        let imageColorSpaceModel = imageRef.colorSpace!.model
        guard imageColorSpaceModel != CGColorSpaceModel.unknown && imageColorSpaceModel != .monochrome else {
            return self
        }
        
//        imageRef.colorSpace!.model
        
        
        let colorspaceRef: CGColorSpace?
        let unsupportedColorSpace = imageColorSpaceModel == .unknown ||
            imageColorSpaceModel == .monochrome ||
            imageColorSpaceModel == CGColorSpaceModel.cmyk ||
            imageColorSpaceModel == .indexed
        
        if unsupportedColorSpace {
            colorspaceRef = CGColorSpaceCreateDeviceRGB()
        }
        else {
            colorspaceRef = imageRef.colorSpace
        }
        
        
//        CGBitmapInfo.init(rawValue: 0)
        
        let width = imageRef.width
        let height = imageRef.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
//        CGBitmapInfo.byteOrderMask.rawValue
        let bitmapInfo = /*CGBitmapInfo.byteOrderDefault.rawValue*/0 | CGImageAlphaInfo.noneSkipLast.rawValue
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorspaceRef!, bitmapInfo: bitmapInfo)
        
        context?.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        
//        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: width, height: height), imageRef)
        let imageRefWithoutAlpha = context!.makeImage()
        let imageWithoutAlpha = UIImage(cgImage: imageRefWithoutAlpha!, scale: self.scale, orientation: self.imageOrientation)
        
        return imageWithoutAlpha
    }
    
}
