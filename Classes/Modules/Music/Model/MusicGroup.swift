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

//let MusicDB: FMDatabaseQueue = MusicGroup.db

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
    /*
    class func `default`() -> MusicGroup {
        guard _default == nil else {
            return _default!
        }
        create(name: DefaultGroupName)
        _default = MusicGroup(name: DefaultGroupName)
        return _default!
    }*/
    
    /// 回调操作队列
    static let operation = OperationQueue.main
    
    /// 创建组
    class func create(name: String, complete: MusicGroupBlock? = nil) {
        MusicDB.inTransaction { (db, rollback) in
            guard let database = db else { return }
            do {
                try database.executeUpdate("CREATE TABLE \(name) (id INTEGER PRIMARY KEY, date DOUBLE)", values: nil)
                try database.executeUpdate("INSERT INTO MusicGroup (name) VALUES (?)", values: [name])
                _groupNames.append(name)
                if complete != nil {
                    operation.addOperation {
                        complete?(MusicGroup(name: name), nil)
                    }
                }
            }
            catch {
                if complete != nil {
                    operation.addOperation {
                        complete?(nil, database.lastError())
                    }
                }
                rollback?.initialize(to: true)
            }
        }
    }
    
    class func delete(name: String, complete: ErrorBlock? = nil) {
        MusicDB.inTransaction { (db, rollback) in
            guard let database = db else { return }
            do {
                try database.executeUpdate("DROP TABLE \(name);", values: nil)
                try database.executeUpdate("DELETE FROM MusicGroup WHERE name = \'\(name)\'", values: nil)
                if complete != nil {
                    operation.addOperation {
                        complete?(nil)
                    }
                }
            }
            catch {
                if complete != nil {
                    operation.addOperation {
                        complete?(database.lastError())
                    }
                }
                rollback?.initialize(to: true)
            }
        }
    }
    
    
    
    
    
    /// 初始化
    init(name: String) {
        self.name = name
    }
    
    
    /// 获取音乐列表
    func list(complete: @escaping MusicListBlock) {
        guard musicList == nil else {
            complete(musicList, nil)
            return
        }
        
        guard !Thread.isMainThread else {
            OperationQueue().addOperation {
                self.list(complete: complete)
            }
            return
        }
        
        MusicDB.inDatabase({ [weak self](db) in
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
                MusicGroup.operation.addOperation {
                    complete(list, nil)
                }
            }
            catch {
                MusicGroup.operation.addOperation {
                    complete([], database.lastError())
                }
            }
        })
    }
    
    
    /// 添加音乐至分组
    
//    func insert(url: URL, complete: ErrorBlock? = nil) {
//        guard let music = Music(url: url) else {
//            complete?(NSError(domain: "音乐对象初始化失败", code: -1, userInfo: nil))
//            return
//        }
//        insert(music: music, complete: complete)
//    }
    
    func insert(music: Music, complete: ErrorBlock? = nil) {
        MusicDB.inDatabase { [weak self](db) in
            guard let database = db else { return }
            guard let weakself = self else { return }
            do {
                let date = Date()
                try database.executeUpdate("INSERT INTO \(weakself.name) (id, date) VALUES (?, ?)", values: [music.id, date.timeIntervalSince1970])
                music.date = date
                weakself.musicList.insert(music, at: 0)
                debugPrint("【\(music.song)】成功添加至歌单【\(weakself.name)】")
                weakself.delegate?.musicGroup(group: weakself, newMusic: music, insertMusicAt: 0)
                if complete != nil {
                    MusicGroup.operation.addOperation {
                        complete?(nil)
                    }
                }
            }
            catch {
                if complete != nil {
                    MusicGroup.operation.addOperation {
                        complete?(database.lastError())
                    }
                }
            }
        }
    }
    
    /// 从分组中删除音乐
    func delete(idx: Int, complete: ErrorBlock? = nil) {
        delete(music: musicList[idx], complete: complete)
    }
    func delete(music: Music, complete: ErrorBlock? = nil) {
        guard let index = musicList.index(of: music) else {
            if complete != nil {
                MusicGroup.operation.addOperation {
                    complete?(NSError(domain: "音乐不存在", code: -1, userInfo: nil))
                }
            }
            return
        }
        MusicDB.inDatabase { [weak self](db) in
            guard let database = db else { return }
            guard let weakself = self else { return }
            do {
                try database.executeUpdate("DELETE FROM \(weakself.name) WHERE id=\(music.id)", values: nil)
                weakself.musicList.remove(at: index)
                weakself.delegate?.musicGroup(group: weakself, deleteMusicAt: index)
                if complete != nil {
                    MusicGroup.operation.addOperation {
                        complete?(nil)
                    }
                }
            }
            catch {
                if complete != nil {
                    MusicGroup.operation.addOperation {
                        complete?(database.lastError())
                    }
                }
            }
        }
    }
    
    
    
    
    // MARK: - ----
    
    fileprivate static var db: FMDatabaseQueue = FMDatabaseQueue(path: DocumentDirectory + "/Music.db")
    
    fileprivate static var _groupNames: [String]!
    
    fileprivate static var _default: MusicGroup?
    
    class func initialize() {
        
        
        
//        db.logsErrors = false
        /*
        guard db.open() else {
            fatalError(db.lastErrorMessage())
        }
        db.setShouldCacheStatements(true)
        */
        
        
        db.inDatabase { (db) in
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
    class func groupNames(complete: @escaping (_ names: [String]) -> Void) {
        guard _groupNames == nil else {
            operation.addOperation {
                complete(_groupNames)
            }
            return
        }
        db.inDatabase { (db) in
            guard let database = db else { return }
            let result = try! database.executeQuery("select name from MusicGroup", values: nil)
            var names = [String]()
            while result.next() {
                if let name = result.string(forColumn: "name") {
                    names.append(name)
                }
            }
            _groupNames = names
            operation.addOperation {
                complete(names)
            }
        }
    }
    
    
    private var musicList: [Music]!
    
    
}

extension MusicGroup: CustomStringConvertible {
    var description: String {
        return "歌单: \(name)"
    }
}

