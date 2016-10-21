//
//  MusicPlayer.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import AVFoundation


enum MusicPlayerState {
    case playing
    case paused
    case stopped
}

enum MusicPlayMode {
    case loopAll    // 列表循环
    case loopSingle // 单曲循环
    case random     // 随机
}

class MusicPlayerNotification {
    static let stateDidChange = NSNotification.Name(rawValue: "MusicPlayer_Notification_StateDidChange")
}



/// 音乐播放器
class MusicPlayer: NSObject {
    
    
    private var list = [Music]()
    
    
    var state: MusicPlayerState = .stopped {
        didSet {
            guard state != oldValue else {
                return
            }
            NotificationCenter.default.post(name: MusicPlayerNotification.stateDidChange, object: self, userInfo: nil)
        }
    }
    
    var mode: MusicPlayMode = .loopAll
    
    static var shared = MusicPlayer()
    
    var isPlaying: Bool {
        guard let player = player else {
            return false
        }
        return player.isPlaying
    }
    
    var currentTime: TimeInterval {
        get {
            guard let player = player else { return 0 }
            return player.currentTime
        }
        set {
            guard let player = player else { return }
            player.currentTime = newValue
        }
    }
    var duration: TimeInterval {
        guard let player = player else { return 0 }
        return player.duration
    }
    
    var currentMusic: Music? {
        didSet {
            print("DidSet: \(currentMusic)")
        }
    }
    
    @discardableResult
    func play(_ music: Music) -> Bool {
        guard music.url != player?.url else {
            if player!.isPlaying {
                pause()
            }
            else {
                play()
            }
            return true
        }
        stop()
        do {
            player = try AVAudioPlayer(contentsOf: music.url)
            player!.delegate = self
            currentMusic = music
            return play()
        }
        catch {
            return false
        }
    }
    
    @discardableResult
    func play() -> Bool {
        guard player != nil else {
            return false
        }
        state = .playing
        return player!.play()
    }
    
    func pause() {
        guard player != nil else {
            return
        }
        player!.pause()
        state = .paused
    }
    
    func stop() {
        guard player != nil else {
            return
        }
        player!.stop()
        player = nil
        state = .stopped
    }
    
    
    
    private var player: AVAudioPlayer?
    
    private override init() {
        super.init()
        try! AVAudioSession.sharedInstance().setActive(true)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    }
    
}

// MARK: - AVAudioPlayerDelegate
extension MusicPlayer: AVAudioPlayerDelegate {
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print(#function)
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        print(#function)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print(#function)
    }
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        print(#function)
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer, withOptions flags: Int) {
        print(#function)
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(#function)
        state = .stopped
        currentMusic?.playCount += 1
    }
}
