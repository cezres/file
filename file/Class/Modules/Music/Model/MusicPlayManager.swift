//
//  MusicPlayManager.swift
//  file
//
//  Created by 翟泉 on 2016/7/2.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import AVFoundation


let PlayStateChangedNotification = NSNotification.Name(rawValue: "PlayStateChanged")

class MusicPlayManager {
    
    enum PlayerState {
        case Playing
        case Paused
        case Stopped
    }
    
    enum PlayMode {
        case loopAll // 列表循环
        case loopSingle // 但单曲循环
        case random // 随机
    }
    
    var playMode: PlayMode = .loopAll
    
    static let `default` = MusicPlayManager()
    
    var state = PlayerState.Stopped {
        didSet {
            NotificationCenter.default().post(name: PlayStateChangedNotification, object: nil)
        }
    }
    let player = AudioPlayer()
    var musicEntitys = [MusicEntity]()
    var currentIndex: Int = 0
    var currentPlaying: MusicEntity?
    let db = MusicDatabase(filePath: DocumentDirectory() + "/MusicPlayList")
    
    weak var delegate: AnyObject?
    
    init() {
        for path in db.select() {
            musicEntitys.append(MusicEntity(path: DocumentDirectory() + path))
        }
    }
    
    func play(path: String) {
        
        for (idx, music) in musicEntitys.enumerated() {
            if music.path == path {
                play(idx: idx)
                return
            }
        }
        
        guard player.play(path: path) else {
            return
        }
        
        musicEntitys.append(MusicEntity(path: path))
        currentPlaying = musicEntitys.last
        currentIndex = musicEntitys.count-1
        
        state = .Playing
        
        guard let range = path.range(of: DocumentDirectory()) else {
            return
        }
        let _path = path.substring(from: range.upperBound)
        db.insert(paths: [_path])
    }
    
    func play(idx: Int) {
        guard idx < musicEntitys.count else {
            return
        }
        guard player.play(path: musicEntitys[idx].path) else {
            return
        }
        
        currentPlaying = musicEntitys[idx]
        currentIndex = idx
        
        state = .Playing
    }
    
    func stop() {
        player.stop()
        currentPlaying = nil
        state = .Stopped
    }
    
    func play() {
        guard player.play() else {
            return
        }
        state = .Playing
    }
    
    func pause() {
        guard player.pause() else {
            return
        }
        state = .Paused
    }
    
    func end() {
//        stop()
        next()
    }
    
    func next() {
        let idx = currentIndex == musicEntitys.count-1 ? 0 : currentIndex + 1
        play(idx: idx)
    }
    
    func prev() {
        let idx = currentIndex == 0 ? musicEntitys.count-1 : currentIndex - 1
        play(idx: idx)
    }
    
}
