//
//  HUDFunctions.swift
//  file
//
//  Created by 翟泉 on 2017/2/23.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


@discardableResult func HUDLoading(in view: UIView? = nil) -> MBProgressHUD? {
    guard Thread.isMainThread else {
        var result: MBProgressHUD?
        DispatchQueue.main.sync {
            result = HUDLoading(in: view)
        }
        return result
    }
    
    let inView: UIView
    if view == nil {
        if let rootView = UIApplication.shared.keyWindow?.rootViewController?.view {
            inView = rootView
        }
        else {
            return nil
        }
    }
    else {
        inView = view!
    }
    
    return MBProgressHUD.showAdded(to: inView, animated: true)
}

func HUDLoadingHidden(for view: UIView? = nil) {
    guard Thread.isMainThread else {
        DispatchQueue.main.sync {
            HUDLoadingHidden(for: view)
        }
        return
    }
    
    let inView: UIView
    if view == nil {
        if let rootView = UIApplication.shared.keyWindow?.rootViewController?.view {
            inView = rootView
        }
        else {
            return
        }
    }
    else {
        inView = view!
    }
    
    MBProgressHUD.hide(for: inView, animated: true)
}

@discardableResult func HUDFailure(message: String, in view: UIView? = nil) -> MBProgressHUD? {
    guard Thread.isMainThread else {
        var result: MBProgressHUD?
        DispatchQueue.main.sync {
            result = HUDFailure(message: message, in: view)
        }
        return result
    }
    
    let inView: UIView
    if view == nil {
        if let rootView = UIApplication.shared.keyWindow?.rootViewController?.view {
            inView = rootView
        }
        else {
            return nil
        }
    }
    else {
        inView = view!
    }
    
    let hud = MBProgressHUD(view: inView)
    hud.label.text = message
    hud.removeFromSuperViewOnHide = true
    inView.addSubview(hud)
    hud.mode = .text
    hud.show(animated: true)
    hud.hide(animated: true, afterDelay: 1.2)
    return hud
}

