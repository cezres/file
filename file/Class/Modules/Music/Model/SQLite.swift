//
//  SQLite.swift
//  file
//
//  Created by 翟泉 on 2016/7/1.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


class SQLite {
    
    
    var handle: OpaquePointer { return _handle! }
    
    private var _handle: OpaquePointer? = nil
    
    
    init(filePath: String) {
        guard sqlite3_open(filePath, &_handle) == SQLITE_OK else {
            return
        }
    }
    
    deinit {
        sqlite3_close(handle)
    }
    
    func exec(sql: String) -> Bool {
        guard sqlite3_exec(handle, sql, nil, nil, nil) == SQLITE_OK else {
            return false
        }
        return true
    }
    
    func table(name: String) {
        var errorMsg: UnsafeMutablePointer<CChar>?
        
        
        
        sqlite3_exec(handle, "pragma table_info ('\(name)');", { (_, nCount, pValue, pName) -> Int32 in
            //
            
            for i in 0..<nCount {
                if let value = pName![Int(i)] {
                    print(String(cString: value))
                }
                if let value = pValue![Int(i)] {
                    print(String(cString: value))
                }
            }
            
            return 0
            }, nil, &errorMsg)
    }
    
}


struct Column {
    let cid: Int
    let name: String
    let type: String
    let notnull: Bool
    let pk: Int
}

class Table {
    
    var columns = [Column]()
    
    func insert() {
        
    }
    
    func delete() {
        
    }
    
    func select() {
        
    }
    
}


