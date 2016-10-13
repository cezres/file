//
//  MusicPlayer.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import AVFoundation

/// 音乐播放器
class MusicPlayer: NSObject {
    
    static var share = MusicPlayer()
    
    private var player: AVAudioPlayer?
    
    private var timer: Timer?
    
    
    private override init() {
        super.init()
        try! AVAudioSession.sharedInstance().setActive(true)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    }
    
    
    @discardableResult
    func play(url: URL) -> Bool {
        guard url != player?.url else {
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
            player = try AVAudioPlayer(contentsOf: url)
            player!.delegate = self
            
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
        return player!.play()
    }
    
    func pause() {
        guard player != nil else {
            return
        }
        player!.pause()
    }
    
    func stop() {
        guard player != nil else {
            return
        }
        player!.stop()
        player = nil
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
    }
}
