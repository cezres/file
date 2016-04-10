//
//  AudioPlayerManager.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveCocoa


enum AudioPlayerState {
    case Playing
    case Paused
    case Stopped
}

class AudioPlayerManager {
    
    static let sharedInstance = AudioPlayerManager()
    
    var playerQueue = PlayerQueue<PlayerQueueItem>()
    
    var audioPlayer = AudioPlayer()
    
    let reloadSignal = RACSubject()
    
    var state: AudioPlayerState = .Stopped
    var playingIndex = -1 {
        didSet {
            guard playingIndex >= 0 else {
                return
            }
            play(playingIndex)
        }
    }
    
    // 播放状态  播放/暂停/停止
    
    // 播放模式  单曲/单曲循环/顺序播放/随机播放
    
    
    func play(filePath: String) {
        
        playingIndex = playerQueue.addItem(PlayerQueueItem(path: filePath))
        
    }
    
    func play(index: Int) {
        state = .Playing
        
        audioPlayer.play(DocumentDirectory() + playerQueue[index].path)
        
        reloadSignal.sendNext(true)
    }
    
    func play() {
        state = .Playing
        
        audioPlayer.play()
        
        reloadSignal.sendNext(true)
    }
    
    func pause() {
        state = .Paused
        
        audioPlayer.pause()
        
        reloadSignal.sendNext(true)
    }
    
    func stop() {
        
        playingIndex = -1
        
        state = .Stopped
        
        audioPlayer.stop()
        
        reloadSignal.sendNext(true)
        
    }
    
    
}


