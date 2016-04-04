//
//  ESAudioManager.swift
//  SwiftRuntime
//
//  Created by 翟泉 on 16/3/30.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import AVFoundation

private var __audioManager: ESAudioManager?


enum ESAudioManagerStatus {
    case Playing
    case Stop
    case Pause
}

protocol ESAudioManagerDelegate {
    
}

class ESAudioManager: NSObject, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer?
    var timer: NSTimer?
    
    class func manager() -> ESAudioManager {
        if __audioManager == nil {
            __audioManager = ESAudioManager()
        }
        return __audioManager!
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - AudioPlayer
    func play(path: String) {
        
        if let audio = audioPlayer {
            audio.stop()
            audioPlayer = nil
        }
        createAudioPlayer(NSURL(fileURLWithPath: path))
        play()
    }
    
    func play() {
        
        if let audio = audioPlayer {
            audio.play()
            startTimer()
        }
    }
    
    func playAtTime(time: NSTimeInterval) {
        
        if let audio = audioPlayer {
            audio.currentTime = time
            if !audio.playing {
                audio.play()
                startTimer()
            }
        }
    }
    
    func pause() {
        
        if let audio = audioPlayer {
            audio.pause()
        }
        stopTimer()
    }
    
    func stop() {
        if let audio = audioPlayer {
            audio.stop()
        }
        audioPlayer = nil
        stopTimer()
    }
    
    // MARK: - Timer
    func startTimer() {
        
        guard timer == nil else {
            return
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1,
            target: self,
            selector: #selector(ESAudioManager.timeInterval),
            userInfo: nil,
            repeats: true
        )
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    func timeInterval() {
        if let audio = audioPlayer {
            print(audio.currentTime, ":", audio.duration)
        }
    }
    
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        print(#function)
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        print(#function)
    }
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print(#function)
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer, withFlags flags: Int) {
        print(#function)
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer, withOptions flags: Int) {
        print(#function)
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print(#function)
        stopTimer()
    }
    
    
    // MARK: - Private
    private func createAudioPlayer(url: NSURL) {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 1
            audioPlayer!.numberOfLoops = 0
//            audioPlayer!.meteringEnabled = true
        }
        catch {
            print(error)
        }
    }
}


