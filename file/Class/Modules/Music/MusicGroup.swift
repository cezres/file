//
//  MusicGroup.swift
//  file
//
//  Created by 翟泉 on 2016/10/13.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import FMDB

private let DefaultGroupName = "默认分组"


func ==(lhs: MusicGroup, rhs: MusicGroup) -> Bool {
    return lhs.name == rhs.name
}

let MusicDB: FMDatabase = MusicGroup.db

/// 歌单
class MusicGroup: NSObject {
    
    let name: String
    
    /// 默认歌单
    class func `default`() -> MusicGroup {
        guard _default == nil else {
            return _default!
        }
        create(name: DefaultGroupName)
        _default = MusicGroup(name: DefaultGroupName)
        return _default!
    }
    
    /// 获取歌单列表
    class func groupNames() -> [String] {
        return _groupNames
    }
    
    /// 创建组
    @discardableResult class func create(name: String) -> Bool {
        let db = MusicDB
        do {
            db.beginTransaction()
            try db.executeUpdate("CREATE TABLE \(name) (id INTEGER PRIMARY KEY, date DOUBLE)", values: nil)
            try db.executeUpdate("INSERT INTO MusicGroup (name) VALUES (?)", values: [name])
            db.commit()
            _groupNames.append(name)
            return true
        }
        catch {
            if db.lastErrorCode() != 1 {
                assertionFailure(db.lastErrorMessage())
            }
            db.commit()
            return false
        }
    }
    @discardableResult class func delete(name: String) -> Bool {
        MusicDB.beginTransaction()
        defer {
            MusicDB.commit()
        }
        do {
            try MusicDB.executeUpdate("DROP TABLE \(name);", values: nil)
            try MusicDB.executeUpdate("", values: nil)
            return true
        }
        catch {
            return false
        }
    }
    
    
    /// 初始化
    init(name: String) {
        
        self.name = name
        
        do {
            let sql = "SELECT Music.*, \(self.name).date FROM \(self.name) INNER JOIN Music ON \(self.name).id = Music.id ORDER BY date DESC"
            let result: FMResultSet = try MusicDB.executeQuery(sql, values: nil)
            while result.next() {
                let ms = Music(result: result)
                ms.date = Date(timeIntervalSince1970: result.double(forColumn: "date"))
                musicList.append(ms)
            }
            result.close()
        }
        catch {
            
        }
        
    }
    
    /// 添加音乐
    @discardableResult func insert(url: URL) -> Bool {
        guard let music = Music(url: url) else {
            return false
        }
        return insert(music: music)
    }
    /// 添加音乐
    @discardableResult func insert(music: Music) -> Bool {
        do {
            let date = Date()
            try MusicDB.executeUpdate("INSERT INTO \(name) (id, date) VALUES (?, ?)", values: [music.id, date.timeIntervalSince1970])
            music.date = date
            musicList.insert(music, at: 0)
            debugPrint("【\(music.song)】成功添加至歌单【\(name)】")
            return true
        }
        catch {
            return false
        }
    }
    
    /// 获取音乐列表
    func list() -> [Music] {
        return musicList
    }
    
    
    // MARK: - ----
    
    fileprivate static var db: FMDatabase = FMDatabase(path: DocumentDirectory + "/Music.db")
    
    private static var _groupNames = [String]()
    
    private static var _default: MusicGroup?
    
    open override class func initialize() {
        guard db.open() else {
            fatalError(db.lastErrorMessage())
        }
        db.setShouldCacheStatements(true)
        
        ///
        do {
            try MusicDB.executeUpdate("CREATE TABLE MusicGroup (name STRING PRIMARY KEY)", values: nil)
        }
        catch {
            
        }
        
        
        let result = try! MusicDB.executeQuery("select name from MusicGroup", values: nil)
        while result.next() {
            if let name = result.string(forColumn: "name") {
                _groupNames.append(name)
            }
        }
    }
    
    
    private var musicList = [Music]()
    
    
    override var description: String {
        return "歌单: \(name)"
    }
    
    
}

