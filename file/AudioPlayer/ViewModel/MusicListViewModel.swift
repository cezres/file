//
//  MusicListViewModel.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicListViewModel {
    
    static let sharedInstance = MusicListViewModel()
    
    var playerQueue = PlayerQueue<PlayerQueueItem>()
    
    let playerManager = AudioPlayerManager.sharedInstance
    
    func play(filePath: String) {
        
    }
    
}
