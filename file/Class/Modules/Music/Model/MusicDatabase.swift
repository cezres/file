//
//  MusicDatabase.swift
//  file
//
//  Created by 翟泉 on 2016/7/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


class MusicDatabase {
    
    var handle: OpaquePointer { return _handle! }
    
    private var _handle: OpaquePointer? = nil
    
    
    init(filePath: String) {
        guard sqlite3_open(filePath, &_handle) == SQLITE_OK else {
            return
        }
        create()
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
    
    
    
    // MusicPlayList
    
    func create() {
        guard exec(sql: "CREATE TABLE PlayList (path STRING);") else {
            return
        }
    }
    
    func insert(paths: [String]) {
        for path in paths {
            guard exec(sql: "INSERT INTO PlayList (path) VALUES (\'\(path)\');") else {
                return
            }
        }
    }
    
    func delete(path: String) {
        guard exec(sql: "DELETE FROM PlayList WHERE path=\'\(path)\';") else {
            return
        }
    }
    
    func deleteAll() {
        guard exec(sql: "DELETE FROM PlayList;") else {
            return
        }
    }
    
    func select() -> [String] {
        var result: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
        var pnRow: Int32 = 0
        var pnColumn: Int32 = 0
        guard sqlite3_get_table(handle, "SELECT * FROM PlayList", &result, &pnRow, &pnColumn, nil) == SQLITE_OK else {
            return []
        }
        
        guard pnRow > 0 && pnColumn > 0 else {
            return []
        }
        
        var paths = [String]()
        
        for row in 1...pnRow {
            for column in 0..<pnColumn {
                guard let cName = result![Int(column)], let cValue = result![Int(column + row * pnColumn)] else {
                    continue
                }
                paths.append(String(cString: cValue))
                print(String(cString: cName), ", ", paths.last!)
            }
        }
        
        return paths
    }
    
}
