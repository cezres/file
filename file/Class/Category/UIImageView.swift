//
//  UIImageView.swift
//  file
//
//  Created by 翟泉 on 2016/6/30.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func photo_centeringForSuperview() {
        guard let imageSize = image?.size else {
            return
        }
        guard let superviewSize = superview?.frame.size else {
            return
        }
        let newFrame: CGRect
        let height = superviewSize.width * imageSize.height / imageSize.width
        if height < superviewSize.height {
            newFrame = CGRect(x: 0, y: (superviewSize.height-height) / 2, width: superviewSize.width, height: height)
        }
        else {
            let width = superviewSize.height * imageSize.width / imageSize.height
            newFrame = CGRect(x: (superviewSize.width-width) / 2, y: 0, width: width, height: superviewSize.height)
        }
        if newFrame != frame {
            frame = newFrame
        }
    }
    
}
