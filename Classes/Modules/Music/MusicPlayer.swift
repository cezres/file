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
    static let stateChanged = NSNotification.Name(rawValue: "MusicPlayer_Notification_stateChanged")
    static let musicChanged = NSNotification.Name(rawValue: "MusicPlayer_Notification_musicChanged")
}



/// 音乐播放器
class MusicPlayer: NSObject {
    
    static var shared = MusicPlayer()
    
    // MARK: - Info
    var state: MusicPlayerState = .stopped {
        didSet {
            guard state != oldValue else {
                return
            }
            configNowPlayingInfoCenter()
            NotificationCenter.default.post(name: MusicPlayerNotification.stateChanged, object: self, userInfo: nil)
        }
    }
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
        configNowPlayingInfoCenter()
        return player.duration
    }
    var currentMusic: Music? {
        didSet {
            NotificationCenter.default.post(name: MusicPlayerNotification.musicChanged, object: nil)
            print("CurrentMusic: \(currentMusic)")
        }
    }
    
    // MARK: Playback
    @discardableResult func play(list: [Music], idx: Int) -> Bool {
        self.list = list
        return play(idx: idx)
    }
    @discardableResult func play(_ music: Music) -> Bool {
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
            try! AVAudioSession.sharedInstance().setActive(true)
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            player = try AVAudioPlayer(contentsOf: music.url)
            player!.delegate = self
            currentMusic = music
            return play()
        }
        catch {
            return false
        }
    }
    @discardableResult func play(idx: Int) -> Bool {
        guard idx < list.count && idx >= 0 else { return false }
        index = idx
        return play(list[idx])
    }
    @discardableResult func play() -> Bool {
        guard player != nil else {
            return false
        }
        guard player!.play() else {
            return false
        }
        state = .playing
        return true
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
    
    // MARK: - Previous/Next
    var mode: MusicPlayMode = .loopAll
    func next() {
        guard list.count > 0 else { return }
        if mode == .loopAll || mode == .loopSingle {
            let idx = index == list.count-1 ? 0 : index + 1
            play(idx: idx)
        }
        else if mode == .random {
            let idx = Int(arc4random_uniform(UInt32(list.count)))
            play(idx: idx)
        }
    }
    
    func previous() {
        guard list.count > 0 else { return }
        let idx = index == 0 ? list.count-1 : index - 1
        play(idx: idx)
    }
    
    
    // MARK: - Private
    private var player: AVAudioPlayer?
    private var list = [Music]()
    private var index = 0
    private override init() {
        super.init()
        configRemoteComtrol()
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
        
        if mode == .loopSingle {
            play(currentMusic!)
        }
        else {
            next()
        }
    }
}
