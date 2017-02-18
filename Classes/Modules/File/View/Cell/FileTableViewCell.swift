//
//  FileTableViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/9/24.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import SnapKit

class FileTableViewCell: UITableViewCell {
    
    var file: File! {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Get
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isOpaque = true
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(self.snp.width).offset(-20)
            make.top.equalTo(10)
        }
        return imageView
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.isOpaque = true
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            make.height.equalTo(label.font.lineHeight*2)
        }
        return label
    }()
    

}


