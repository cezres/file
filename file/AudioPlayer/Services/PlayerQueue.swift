//
//  PlayerQueue.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


class PlayerQueue<T: QueueProtocol> {
    
    private var items = [T]()
    
    private var randomPlayerQueue = [Int]()
    
    var count: Int {
        return items.count
    }
    
    var currentIndex = 0
    
    init() {
        loadItems()
        print(String(T))
    }
    
    subscript(index: Int) -> T {
        return items[index]
    }
    
    
    
    func next() -> T {
        if currentIndex+1 == items.count {
            currentIndex = 0
        }
        else {
            currentIndex += 1
        }
        if randomPlayerQueue.count != 0 {
            return items[randomPlayerQueue[currentIndex]]
        }
        else {
            return items[currentIndex]
        }
    }
    
    
    
    /**
     随机排序
     */
    func random() {
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
        Pantry.pack(items, key: "PlayerQueue")
    }
    
    /**
     读取
     */
    func loadItems() {
        if let _items: [T] = Pantry.unpack("PlayerQueue") {
            items = _items
        }
    }
    
}


extension PlayerQueue {
    
    func addItem(item: T) -> Int {
        
        for (idx, obj) in items.enumerate() {
            if item == obj {
                return idx
            }
        }
        
        items.append(item)
        
        saveItems()
        
        return items.count-1
    }
    
    func remove(idx: Int) {
        items.removeAtIndex(idx)
    }
    
    func remove(item: T) {
        for (idx, obj) in items.enumerate() {
            if item == obj {
                items.removeAtIndex(idx)
                return
            }
        }
    }
}