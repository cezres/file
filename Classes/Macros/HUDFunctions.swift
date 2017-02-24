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

func HUDLoading(in view: UIView) -> MBProgressHUD {
    return MBProgressHUD.showAdded(to: view, animated: true)
}

func HUDLoadingHidden(for view: UIView) {
    MBProgressHUD.hide(for: view, animated: true)
}

@discardableResult func HUDFailure(message: String, in view: UIView? = nil) -> MBProgressHUD? {
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

