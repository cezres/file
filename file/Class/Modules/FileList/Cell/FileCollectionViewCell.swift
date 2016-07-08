//
//  FileCollectionViewCell.swift
//  file
//
//  Created by cezr on 16/6/23.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit

class FileCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white()
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFileEntity(file: FileEntity) {
        imageView.backgroundColor = UIColor.white()
        
        switch file.type {
        case .Photo:
            ThumbnailCache.sharedInstance.thumbnail(imagePath: file.path, width: frame.width, callback: { (path, image) in
                if path == file.path {
                    self.imageView.image = image
                }
            })
        case .Directory:
            imageView.image = UIImage(named: "Directory")
        case .Audio:
            imageView.image = UIImage(named: "Audio")
        case .Video:
            imageView.image = UIImage(named: "Video")
        case .Unknown:
            imageView.image = UIImage(named: "Unknown")
        }
        
        nameLabel.text = file.name
        nameLabel.snp_updateConstraints { (make) in
            let height = nameLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: frame.width, height: 40), limitedToNumberOfLines: 2).height
            make.height.equalTo(height)
        }
    }
    
    class func height(width: CGFloat) -> CGFloat {
        return width + UIFont.systemFont(ofSize: 12).lineHeight*2+10
    }
    
    func loadSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.textColor = UIColor(white: 34/255.0, alpha: 1.0)
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        
        imageView.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(self.snp_width).offset(-20)
            make.top.equalTo(10)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(imageView.snp_bottom).offset(10)
            make.height.equalTo(nameLabel.font.lineHeight*2)
        }
        
    }
    
}
