//
//  MusicSearchResultView.swift
//  file
//
//  Created by 翟泉 on 2016/11/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

/// 音乐搜索结果视图
class MusicSearchResultView: UIView {

    init() {
        super.init(frame: CGRect())
        backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func search(_ search: String) {
        print(search)
    }
    
}
