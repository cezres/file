//
//  MyMusicHeaderView.swift
//  file
//
//  Created by 翟泉 on 2016/11/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MyMusicHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ColorWhite(240)
        textLabel?.textColor = ColorWhite(100)
        textLabel?.font = Font(14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

