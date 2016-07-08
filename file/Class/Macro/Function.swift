//
//  Function.swift
//  file
//
//  Created by 翟泉 on 2016/7/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


func timeToString(time: TimeInterval) -> String {
    let iTime = Int(time)
    let minute = iTime / 60
    return String(format: "%02d:%02d", minute, iTime - minute*60)
}
