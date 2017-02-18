//
//  MusicPlayer+NowPlayingInfo.swift
//  file
//
//  Created by 翟泉 on 2016/10/24.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import MediaPlayer

extension MusicPlayer {
    
    func configNowPlayingInfoCenter() {
        var info = [String: Any]()
        defer {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }
        
        guard let music = currentMusic else { return }
        
        info[MPMediaItemPropertyTitle] = music.song
        info[MPMediaItemPropertyArtist] = music.singer
        info[MPMediaItemPropertyAlbumTitle] = music.albumName
        info[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: music.duration)
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: currentTime)
        
        
        
        if let artworkImage = music.artwork {
            let artwork = MPMediaItemArtwork(image: artworkImage)
            info[MPMediaItemPropertyArtwork] = artwork
        }
    }
    
}
