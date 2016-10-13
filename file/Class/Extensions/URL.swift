//
//  URL.swift
//  file
//
//  Created by 翟泉 on 2016/10/12.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation

extension URL {
    static var documentDirectory: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    static var cachesDirectory: URL {
        return try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
