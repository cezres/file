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

let MusicDB: FMDatabaseQueue = FMDatabaseQueue(path: DocumentDirectory + "/Music.db")


protocol MusicGroupDelegate: NSObjectProtocol {
    func musicGroup(group: MusicGroup, newMusic music: Music, insertMusicAt index: Int)
    func musicGroup(group: MusicGroup, deleteMusicAt index: Int)
}

typealias MusicGroupBlock = (_ group: MusicGroup?, _ error: Error?) -> Void
typealias MusicListBlock = (_ list: [Music], _ error: Error?) -> Void

/// 歌单
class MusicGroup {
    
    let name: String
    
    weak var delegate: MusicGroupDelegate?
    
    /// 默认歌单
    static let `default` = MusicGroup(name: DefaultGroupName)
    
    private var musicList: [Music]!
    
    /// 初始化
    init(name: String) {
        self.name = name
    }
    
    /// 获取音乐列表
    func list() -> [Music] {
        guard musicList == nil else {
            return musicList
        }
        MusicDB.inDatabase { [weak self](db) in
            guard let database = db else { return }
            guard let weakself = self else { return }
            do {
                let sql = "SELECT Music.*, \(weakself.name).date FROM \(weakself.name) INNER JOIN Music ON \(weakself.name).id = Music.id ORDER BY date DESC"
                let result: FMResultSet = try database.executeQuery(sql, values: nil)
                var list = [Music]()
                while result.next() {
                    let ms = Music(result: result)
                    ms.date = Date(timeIntervalSince1970: result.double(forColumn: "date"))
                    list.append(ms)
                }
                result.close()
                weakself.musicList = list
            }
            catch {
                fatalError(database.lastErrorMessage())
            }
        }
        return musicList
    }
    
    /// 添加音乐至歌单
    ///
    /// - Parameter music: Music对象
    /// - Returns: TRUE添加成功/FALSE已存在
    @discardableResult func insert(music: Music) -> Bool {
        if musicList != nil && musicList.contains(music) {
            return false
        }
        var result = false
        MusicDB.inDatabase { [weak self](db) in
            guard let database = db else { return }
            guard let weakself = self else { return }
            do {
                let date = Date()
                try database.executeUpdate("INSERT INTO \(weakself.name) (id, date) VALUES (?, ?)", values: [music.id, date.timeIntervalSince1970])
                music.date = date
                if weakself.musicList != nil {
                    weakself.musicList.insert(music, at: 0)
                    debugPrint("【\(music.song)】成功添加至歌单【\(weakself.name)】")
                }
                weakself.delegate?.musicGroup(group: weakself, newMusic: music, insertMusicAt: 0)
                result = true
            }
            catch {
                debugPrint(database.lastErrorMessage())
                result = false
            }
        }
        return result
    }
    
    /// 从分组中删除音乐
    ///
    /// - Parameter idx: <#idx description#>
    /// - Returns: <#return value description#>
    @discardableResult func delete(idx: Int) -> Bool {
        return delete(music: musicList[idx])
    }
    
    /// 从分组中删除音乐
    ///
    /// - Parameter music: <#music description#>
    /// - Returns: <#return value description#>
    @discardableResult func delete(music: Music) -> Bool {
        guard let index = musicList.index(of: music) else {
            return false
        }
        var result = false
        MusicDB.inDatabase { [weak self](db) in
            guard let database = db else { return }
            guard let weakself = self else { return }
            do {
                try database.executeUpdate("DELETE FROM \(weakself.name) WHERE id=\(music.id)", values: nil)
                weakself.musicList.remove(at: index)
                weakself.delegate?.musicGroup(group: weakself, deleteMusicAt: index)
                result = true
            }
            catch {
                result = false
            }
        }
        return result
    }
    
    
    
    
    
    // MARK: - Class
    
    fileprivate static var _groupNames: [String]!
    fileprivate static var _default: MusicGroup?
    
    class func initialize() {
        guard let database = MusicDB.database() else { return }
        database.logsErrors = false
        database.setShouldCacheStatements(false)
        MusicDB.inDatabase { (db) in
            guard let database = db else { return }
            do {
                try database.executeUpdate("CREATE TABLE MusicGroup (name STRING PRIMARY KEY)", values: nil)
            }
            catch {
                
            }
        }
        /// 创建默认分组
        create(name: DefaultGroupName)
    }
    
    
    /// 获取歌单列表
    ///
    /// - Returns: <#return value description#>
    class func groupNames() -> [String] {
        guard _groupNames == nil else {
            return _groupNames
        }
        MusicDB.inDatabase { (db) in
            guard let database = db else { return }
            let result = try! database.executeQuery("select name from MusicGroup", values: nil)
            var names = [String]()
            while result.next() {
                if let name = result.string(forColumn: "name") {
                    names.append(name)
                }
            }
            _groupNames = names
        }
        return _groupNames
    }
    
    /// 创建歌单
    ///
    /// - Parameter name: <#name description#>
    /// - Returns: <#return value description#>
    @discardableResult class func create(name: String) -> MusicGroup? {
        var group: MusicGroup?
        MusicDB.inTransaction { (db, rollback) in
            guard let database = db else { return }
            do {
                try database.executeUpdate("CREATE TABLE \(name) (id INTEGER PRIMARY KEY, date DOUBLE)", values: nil)
                try database.executeUpdate("INSERT INTO MusicGroup (name) VALUES (?)", values: [name])
                _groupNames.append(name)
                group = MusicGroup(name: name)
            }
            catch {
                debugPrint(database.lastErrorMessage())
                rollback?.initialize(to: true)
            }
        }
        return group
    }
    
    /// 删除歌单
    ///
    /// - Parameter name: <#name description#>
    /// - Returns: <#return value description#>
    @discardableResult class func delete(name: String) -> Bool {
        var result = false
        MusicDB.inTransaction { (db, rollback) in
            guard let database = db else { return }
            do {
                try database.executeUpdate("DROP TABLE \(name);", values: nil)
                try database.executeUpdate("DELETE FROM MusicGroup WHERE name = \'\(name)\'", values: nil)
                result = true
            }
            catch {
                result = false
                rollback?.initialize(to: true)
            }
        }
        return result
    }
    
    
    
    
}

extension MusicGroup: CustomStringConvertible {
    var description: String {
        return "歌单: \(name)"
    }
}

