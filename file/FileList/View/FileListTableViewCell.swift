//
//  FileListTableViewCell.swift
//  file
//
//  Created by 翟泉 on 16/4/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import SnapKit

class FileListTableViewCell: UITableViewCell {
    
    var file: File?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconImageView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.centerY.equalTo(self.snp_centerY)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(16)
            make.bottom.equalTo(self.snp_centerY)
        }
        
        descriptionLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_centerY)
            make.height.equalTo(16)
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.right.equalTo(-10)
        }
        
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
    
    class func height(file: File) -> CGFloat {
        return 40.0
    }
    
    func setupData(file: File) {
        self.file                  = file
        self.nameLabel.text        = file.lastPathComponent
        self.descriptionLabel.text = file.type.description
        
        
        switch file.type {
        case .Photo:
            ThumbnailCache.sharedInstance.loadThumbnail(file.path, width: 100, callback: { (path, thumbnail) in
                if self.file?.path == path {
                    self.iconImageView.image = thumbnail
                }
                else {
                    print("Error:", path, self.file?.path)
                }
            })
            break
        default:
            iconImageView.image = UIImage(named: file.type.iconName)
        }
        
        
    }
    
    lazy var iconImageView: UIImageView = {
        let lazy = UIImageView()
        self.contentView.addSubview(lazy)
        return lazy
    }()
    
    lazy var nameLabel: UILabel = {
        let lazy  = UILabel()
        lazy.font = Font(13)
        self.contentView.addSubview(lazy)
        return lazy
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lazy  = UILabel()
        lazy.font = Font(11)
        self.contentView.addSubview(lazy)
        return lazy
    }()

}
