//
//  MusicListTableViewCell.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import ESTMusicIndicator

class MusicListTableViewCell: UITableViewCell {
    
    var musicIndicator = ESTMusicIndicatorView()
    var musicTitleLabel = UILabel()
    
    var state: ESTMusicIndicatorViewState = .ESTMusicIndicatorViewStateStopped {
        didSet {
            musicIndicator.state = state
//            musicNumberLabel.hidden = state != .ESTMusicIndicatorViewStateStopped
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        musicTitleLabel.font = Font(13)
        
        addSubview(musicIndicator)
        addSubview(musicTitleLabel)
        
        musicIndicator.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(30)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        musicTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(musicIndicator.snp_right)
            make.right.equalTo(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        musicIndicator.state = .ESTMusicIndicatorViewStateStopped
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
