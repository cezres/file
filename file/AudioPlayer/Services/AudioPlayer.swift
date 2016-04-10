//
//  AudioPlayer.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    var timer: NSTimer?
    
    
    // MARK: - AudioPlayer
    func play(path: String) {
        
        if let _ = audioPlayer {
            stop()
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
            1/10.0,
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
//        if let audio = audioPlayer {
//            print(audio.currentTime, ":", audio.duration)
//        }
    }
    
    
    // MARK: - Private
    private func createAudioPlayer(url: NSURL) {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer!.delegate = self
//            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 1
            audioPlayer!.numberOfLoops = 0
            //            audioPlayer!.meteringEnabled = true
            
            
//            let asset = AVAsset(URL: url)
//            for format in asset.availableMetadataFormats {
//                for item in asset.metadataForFormat(format) {
//                    print(item.commonKey, item.value)
//                }
//            }
            
        }
        catch {
            print(error)
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
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
        AudioPlayerManager.sharedInstance.stop()
    }
}



