//
//  PlayerQueueItem.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


typealias QueueProtocol = protocol<Storable,Equatable>

struct PlayerQueueItem: QueueProtocol {
    let path: String
    let name: String
    init(path: String) {
        self.path = path
        name = NSString(string: NSString(string: path).lastPathComponent).stringByDeletingPathExtension
    }
}

extension PlayerQueueItem {
    init?(warehouse: Warehouseable) {
        path = warehouse.get("path") ?? ""
        name = NSString(string: path).lastPathComponent
    }
    func toDictionary() -> [String : AnyObject] {
        return ["path": path]
    }
}


func ==(lhs: PlayerQueueItem, rhs: PlayerQueueItem) -> Bool {
    return lhs.path == rhs.path
}