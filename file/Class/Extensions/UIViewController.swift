//
//  UIViewController.swift
//  file
//
//  Created by 翟泉 on 2016/11/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


extension UIViewController {
    
    class var rootViewController: UIViewController {
        get {
            return UIApplication.shared.keyWindow!.rootViewController!
        }
    }
    
}
