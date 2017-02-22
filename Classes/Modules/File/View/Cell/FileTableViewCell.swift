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
            guard file != oldValue else {
                return
            }
            nameLabel.text = file.name
            nameLabel.layoutIfNeeded()
            nameLabel.snp.updateConstraints { (make) in
                let height = nameLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: nameLabel.width, height: 90), limitedToNumberOfLines: 2).size.height
                make.height.equalTo(height)
            }
            
            iconImageView.image = nil
            FileThumbnail.shared.thumbnail(file: file) { [weak self](file, image) in
                if file == self?.file {
                    self?.iconImageView.image = image
                }
            }
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
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(15)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(nameLabel.font.lineHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Get
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isOpaque = true
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.isOpaque = true
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        return label
    }()
    

}


