//
//  MyMusicModel.swift
//  file
//
//  Created by 翟泉 on 2016/11/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MyMusicModel {
    
    var groups = [MyMusicGroupEntity]()
    
    init() {
        let defaultGroup = MyMusicGroupEntity()
        defaultGroup.title = "默认分组"
        defaultGroup.contents = ["下载音乐", "最近播放", "我的听歌排行", "本地音乐"]
        
        groups = [defaultGroup]
    }
    
    
}
