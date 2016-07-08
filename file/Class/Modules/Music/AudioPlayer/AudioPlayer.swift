//
//  AudioPlayer.swift
//  file
//
//  Created by 翟泉 on 2016/6/30.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject {
    
    private var player: AVAudioPlayer!
    private var timer: Timer!
    
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    var currentTime: TimeInterval {
        get {
            guard player != nil else {
                return 0
            }
            return player.currentTime
        }
        set {
            guard player != nil else {
                return
            }
            player.currentTime = newValue
        }
    }
    
    var duration: TimeInterval {
        guard player != nil else {
            return 0
        }
        return player.duration
    }
    
    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            
        }
    }
    
    
    func play(path: String) -> Bool {
        if player != nil {
            stop()
        }
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.delegate = self
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
        guard player.play() else {
            return false
        }
        return true
    }
    
    func pause() -> Bool {
        guard player != nil else {
            return false
        }
        player.pause()
        return true
    }
    
    
    func stop() {
        guard player != nil else {
            return
        }
        player.stop()
        player = nil
    }
    
    
    
}


extension AudioPlayer: AVAudioPlayerDelegate {
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print(#function)
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        print(#function)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: NSError?) {
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
        MusicPlayManager.default.end()
    }
}
