//
//  MyMusicTableViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/11/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MyMusicTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    var separatorView: UIView!
//    
//    var isHiddenSeparator: Bool {
//        get {
//            return separatorView.isHidden
//        }
//        set {
//            separatorView.isHidden = newValue
//        }
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        separatorView = UIView()
//        separatorView.backgroundColor = ColorWhite(220)
//        contentView.addSubview(separatorView)
//        separatorView.snp.makeConstraints { (make) in
//            make.left.equalTo(30)
//            make.top.equalTo(0)
//            make.right.equalTo(0)
//            make.height.equalTo(0.5)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
