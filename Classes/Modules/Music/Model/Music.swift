//
//  Music.swift
//  file
//
//  Created by 翟泉 on 2016/10/13.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import FMDB
import AVFoundation

typealias MusicBlock = (_ music: Music?, _ error: Error?)  -> Void

class Music {
    
    let url: URL    //
    
    let id: Int64       // ID  path.hash
    let path: String    // 路径  相对Home的路径
    let song: String    // 歌曲名
    let singer: String  // 歌手
    let albumName: String   // 专辑名
    let duration: Double    // 时长
    // 播放次数
    var playCount: Int32 = 0 {
        didSet {
            MusicDB.inDatabase { (db) in
                guard let database = db else { return }
                do {
                    try database.executeUpdate("update Music set playCount=\(self.playCount) where id=\(self.id)", values: nil)
                }
                catch {
                    
                }
            }
        }
    }
    // 封面
    lazy var artwork: UIImage? = {
        return Music.artwork(url: self.url)
    }()
    
    var date: Date? // 添加入歌单的日期
    
    /// 初始化音乐对象
    ///
    /// - Parameters:
    ///   - url: 音频文件路径
    init?(url: URL) {
        path = url.absoluteString.relativePath.urlDecode
        id = Int64(path.hash)
        var _song: String?
        var _singer: String?
        var _albumName: String?
        var _duration: Double = 0
        var _playCount: Int32 = 0
        
        let _id = id
        MusicDB.inDatabase { (db) in
            guard let database = db else { return }
            do {
                /// 从数据库中查找
                let result = try database.executeQuery("select * from Music where id=\(_id)", values: nil)
                if result.next() {
                    _song = result.string(forColumn: "song") ?? ""
                    _singer = result.string(forColumn: "singer") ?? ""
                    _albumName = result.string(forColumn: "albumName") ?? ""
                    _duration = result.double(forColumn: "duration")
                    _playCount = result.int(forColumn: "playCount")
                }
                result.close()
            }
            catch {
                fatalError(database.lastErrorMessage())
            }
        }
        
        self.url = url
        
        /// 根据数据库返回数据创建对象
        if _song != nil {
            song = _song ?? ""
            singer = _singer ?? ""
            albumName = _albumName ?? ""
            duration = _duration
            playCount = _playCount
        }
        else {
            /// 根据文件创建对象
            let asset = AVURLAsset(url: url)
            duration = TimeInterval(asset.duration.value) / TimeInterval(asset.duration.timescale)
            guard duration > 0 else {
                return nil
            }
            /// 读取音频文件信息
            _song = path.lastPathComponent.deletingPathExtension
            for format in asset.availableMetadataFormats {
                for metadataItem in asset.metadata(forFormat: format) {
                    if metadataItem.commonKey == "title" {
                        if let string = metadataItem.value as? String {
                            _song = string
                        }
                    }
                    else if metadataItem.commonKey == "artist" {
                        _singer = metadataItem.value as? String
                    }
                    else if metadataItem.commonKey == "albumName" {
                        _albumName = metadataItem.value as? String
                    }
                }
            }
            song = _song!
            singer = _singer ?? "未知"
            albumName = _albumName ?? "未知"
        }
    }
    
    deinit {
        
    }
    
    
    
    
    
    /// 获取音频文件插图
    class func artwork(url: URL) -> UIImage? {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && !isDirectory.boolValue else {
            return nil
        }
        var result: UIImage?
        let asset = AVURLAsset(url: url)
        for format in asset.availableMetadataFormats {
            for metadataItem in asset.metadata(forFormat: format) {
                if metadataItem.commonKey == "artwork" {
                    if let data = metadataItem.value as? Data {
                        result = UIImage(data: data)
                    }
                    break
                }
            }
        }
        return result
    }
    
    init(result: FMResultSet) {
        id = result.longLongInt(forColumn: "id")
        path = result.string(forColumn: "path")
        song = result.string(forColumn: "song") ?? ""
        singer = result.string(forColumn: "singer") ?? ""
        albumName = result.string(forColumn: "albumName") ?? ""
        duration = result.double(forColumn: "duration")
        playCount = result.int(forColumn: "playCount")
        url = URL(fileURLWithPath: HomeDirectory + path)
    }
    
//    func insert() throws {
//        let sql = "INSERT INTO Music (id, path, song, singer, artwork, albumName, duration) VALUES (?, ?, ?, ?, ?, ?, ?)"
//        try MusicDB.executeUpdate(sql, values: [path.hash, path, song, singer, artwork, albumName, duration])
//    }
    
    func delete() {
        let musicId = id
        MusicDB.inDatabase { (db) in
            guard let database = db else { return }
            do {
                try database.executeUpdate("DELETE FROM Music WHERE id=\(musicId)", values: nil)
            }
            catch {
                
            }
        }
    }
    // http://music.163.com/weapi/search/suggest/web?csrf_token=a114ec208ef0d27171b4c34118902c41
    // http://s1.music.126.net/download/osx/NeteaseMusic_1.4.5_488_web.dmg
    
    // MARK: - -----
    
    class func initialize() {
        /// 创建音乐数据库表
        guard let database = MusicDB.database() else { return }
        database.logsErrors = false
        database.setShouldCacheStatements(false)
        
        MusicDB.inDatabase { (db) in
            guard let database = db else { return }
            do {
                try database.executeUpdate("CREATE TABLE Music (id INTEGER PRIMARY KEY, path STRING NOT NULL UNIQUE, song TEXT, singer STRING, artwork STRING, albumName STRING, duration DOUBLE DEFAULT (0), playCount INTEGER DEFAULT (0))", values: nil)
            }
            catch {
//                debugPrint(database.lastErrorMessage())
            }
        }
    }
    
    
    
}


extension Music: CustomStringConvertible {
    var description: String {
        return "ID: \(id) \n歌曲名: \(song) \n歌手: \(singer) \n专辑名: \(albumName) \n时长: \(Int(duration)) \n播放次数: \(playCount) \n日期: \(date) \n"
    }
}

func ==(lhs: Music, rhs: Music) -> Bool {
    return lhs.id == rhs.id
}

extension Music: Equatable {
}

