//
//  MusicTableViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/7/1.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    
    let musicIndicator = ESTMusicIndicatorView()
    let musicTitleLabel = UILabel()
    
    
    
    var state: ESTMusicIndicatorViewState = .ESTMusicIndicatorViewStateStopped {
        didSet {
            musicIndicator.state = state
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        musicTitleLabel.font = UIFont.systemFont(ofSize: 13)
        musicIndicator.state = .ESTMusicIndicatorViewStateStopped
        
        separatorInset = UIEdgeInsetsZero
        
        contentView.addSubview(musicTitleLabel)
        contentView.addSubview(musicIndicator)
        
        musicIndicator.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(self.snp_height)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        musicTitleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(musicIndicator.snp_right)
            make.right.equalTo(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
