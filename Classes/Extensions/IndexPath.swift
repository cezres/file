//
//  IndexPath.swift
//  file
//
//  Created by 翟泉 on 2017/2/23.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import Foundation


extension IndexPath {
    
    static func indexs(for indexs: [Int], section: Int = 0) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for idx in indexs {
            indexPaths.append(IndexPath(row: idx, section: 0))
        }
        return indexPaths
    }
    
}
