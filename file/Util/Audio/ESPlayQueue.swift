//
//  ESPlayQueue.swift
//  file
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import SQLite

public func ==(lhs: ESPlayerQueueItem, rhs: ESPlayerQueueItem) -> Bool {
    return lhs.path == rhs.path
}

public struct ESPlayerQueueItem: ESQueueProtocol {
    var name: String {
        return NSString(string: path).lastPathComponent
    }
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    public init?(warehouse: Warehouseable) {
        self.path = warehouse.get("path") ?? ""
    }
    
    public func toDictionary() -> [String : AnyObject] {
        return [
            "path": path,
        ]
    }
}

protocol ESQueueProtocol: Storable,Equatable {
}

struct ESQueue<T: ESQueueProtocol> {
    private var items: [T]
    
    init(items: [T]) {
        self.items = items
        
        let ss = String(T)
        print(ss)
    }
    
    subscript(index: Int) -> T {
        return items[index]
    }
    
    mutating func addItem(item: T) {
        items.append(item)
    }
    
    mutating func remove(idx: Int) {
        items.removeAtIndex(idx)
    }
    
    mutating func remove(item: T) {
        for (idx, obj) in items.enumerate() {
            if item == obj {
                items.removeAtIndex(idx)
                return
            }
        }
    }
    
    /**
     随机排序
     */
    mutating func random() {
        
        for _ in 0 ..< items.count {
            let randomIndex1 = Int(arc4random_uniform(UInt32(items.count)))
            let randomIndex2 = Int(arc4random_uniform(UInt32(items.count)))
            let tempItem = items[randomIndex1]
            items[randomIndex1] = items[randomIndex2]
            items[randomIndex2] = tempItem
        }
    }
    
    /**
     存储
     */
    func saveItems() {
        Pantry.pack(items, key: "ESAudioQueueItems")
        
        
        
    }
    
    /**
     读取
     */
    mutating func loadItems() {
        if let _items: [T] = Pantry.unpack("ESAudioQueueItems") {
            items = _items
        }
        
        UIControlState.Normal
        
        
    }
    
    
}