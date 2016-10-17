//
//  MusicGroupTableViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/10/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicGroupTableViewCell: SWTableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textAlignment = .center
        
        separatorInset = UIEdgeInsets()
        layoutMargins = UIEdgeInsets()
        
        let delButton = UIButton(type: .system)
        delButton.setTitle("删除", for: .normal)
        delButton.setTitleColor(UIColor.white, for: .normal)
        delButton.backgroundColor = ColorRGB(253, 85, 98)
        setRightUtilityButtons([delButton], withButtonWidth: 70)
        
        
        
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
