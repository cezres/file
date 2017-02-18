//
//  Equatable.swift
//  file
//
//  Created by 翟泉 on 2016/9/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


extension Equatable {
    
    /**
     是否在集合中
     
     - parameter collection: <#collection description#>
     
     - returns: <#return value description#>
     */
    func isIn(collection: [Self]) -> Bool {
        return collection.contains(self)
    }
    
    /**
     是否在集合中
     
     - parameter collection: <#collection description#>
     
     - returns: <#return value description#>
     */
    func isIn(collection: Self...) -> Bool {
        return collection.contains(self)
    }
    
}

