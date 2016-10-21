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


class Music: NSObject {
    
    let url: URL    //
    
    let id: Int64       // ID  path.hash
    let path: String    // 路径  相对Home的路径
    let song: String    // 歌曲名
    let singer: String  // 歌手
    let artwork: String // 封面
    let albumName: String   // 专辑名
    let duration: Double    // 时长
    // 播放次数
    var playCount: Int32 = 0 {
        didSet {
            do {
                try MusicDB.executeUpdate("update Music set playCount=\(playCount) where id=\(id)", values: nil)
            }
            catch {
                
            }
        }
    }
    
    var date: Date? // 添加入歌单的日期
    
    lazy var artworkURL: URL? = {
        guard self.artwork != "" else {
            return nil
        }
        return URL(fileURLWithPath: CachesDirectory + "/Music_artwork/" + self.artwork)
    }()
    
    
    
    
    /// 初始化音乐对象
    init?(url: URL) {
        
        self.url = url
        path = url.absoluteString.relativePath.urlDecode
        id = Int64(path.hash)
        
        /// 从数据库中查找
        do {
            let result = try MusicDB.executeQuery("select * from Music where id=\(path.hash)", values: nil)
            if result.next() {
                song = result.string(forColumn: "song") ?? ""
                singer = result.string(forColumn: "singer") ?? ""
                artwork = result.string(forColumn: "artwork") ?? ""
                albumName = result.string(forColumn: "albumName") ?? ""
                duration = result.double(forColumn: "duration")
                playCount = result.int(forColumn: "playCount")
                result.close()
                
                debugPrint("SQLite->Music")
                return
            }
        }
        catch {
            fatalError(MusicDB.lastErrorMessage())
        }
        
        /// 新建对象，添加至数据库
        let asset = AVURLAsset(url: url)
        duration = TimeInterval(asset.duration.value) / TimeInterval(asset.duration.timescale)
        if duration <= 0 {
            return nil
        }
        var _song: String = path.lastPathComponent.deletingPathExtension
        var _singer: String?
        var _albumName: String?
        var _artwork: String?
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
                else if metadataItem.commonKey == "artwork" {
                    if let data = metadataItem.value as? Data {
                        do {
                            let url = URL(fileURLWithPath: CachesDirectory + "/Music_artwork/" + path.md5)
                            try data.write(to: url)
                            _artwork = path.md5
                        }
                        catch {
                            
                        }
                        continue
                    }
                    else {
                        debugPrint("xxxxx")
                    }
                }
            }
        }
        song = _song
        singer = _singer ?? ""
        artwork = _artwork ?? ""
        albumName = _albumName ?? ""
        
        do {
            let sql = "insert into Music (id, path, song, singer, artwork, albumName, duration) values (?, ?, ?, ?, ?, ?, ?)"
            let values = [path.hash, path, song, singer, artwork, albumName, duration] as [Any]
            try MusicDB.executeUpdate(sql, values: values)
            debugPrint("INSERT->Music")
        }
        catch {
            fatalError("Music INSERT ERROR: \(url)")
        }
        
    }
    
    init(result: FMResultSet) {
        id = result.longLongInt(forColumn: "id")
        path = result.string(forColumn: "path")
        song = result.string(forColumn: "song") ?? ""
        singer = result.string(forColumn: "singer") ?? ""
        artwork = result.string(forColumn: "artwork") ?? ""
        albumName = result.string(forColumn: "albumName") ?? ""
        duration = result.double(forColumn: "duration")
        playCount = result.int(forColumn: "playCount")
        
        url = URL(fileURLWithPath: HomeDirectory + path)
    }
    
    func insert() throws {
        let sql = "INSERT INTO Music (id, path, song, singer, artwork, albumName, duration) VALUES (?, ?, ?, ?, ?, ?, ?)"
        try MusicDB.executeUpdate(sql, values: [path.hash, path, song, singer, artwork, albumName, duration])
    }
    
    // MARK: - -----
    open override class func initialize() {
        guard MusicDB.open() else {
            fatalError(MusicDB.lastErrorMessage())
        }
        MusicDB.setShouldCacheStatements(true)
        do {
            /// 创建音乐数据库表
            try MusicDB.executeUpdate("CREATE TABLE Music (id INTEGER PRIMARY KEY, path STRING NOT NULL UNIQUE, song TEXT, singer STRING, artwork STRING, albumName STRING, duration DOUBLE DEFAULT (0), playCount INTEGER DEFAULT (0))", values: nil)
        }
        catch {
            
        }
        
        do {
            try FileManager.default.createDirectory(atPath: CachesDirectory + "/Music_artwork", withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            
        }
        
    }
    
    override var description: String {
        return "ID: \(id) \n歌曲名: \(song) \n歌手: \(singer) \n专辑名: \(albumName) \n时长: \(Int(duration)) \n播放次数: \(playCount) \n日期: \(date) \n"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let music = object as? Music else {
            return false
        }
        return id == music.id
    }
    
}


