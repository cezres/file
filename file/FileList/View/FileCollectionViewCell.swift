//
//  FileCollectionViewCell.swift
//  file
//
//  Created by 翟泉 on 16/5/17.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit

class FileCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.snp_makeConstraints { (make) in
            make.width.equalTo(self.contentView.snp_width).offset(-20)
            make.height.equalTo(self.contentView.snp_width).offset(-20)
            make.top.equalTo(10)
            make.centerX.equalTo(0)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(14)
        }
        
        editingImageView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(30, 30))
            make.top.equalTo(0)
            make.right.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(file: File) {
        self.nameLabel.text = file.lastPathComponent
        
        switch file.type {
        case .Photo:
            ThumbnailCache.sharedInstance.loadThumbnail(file.path, width: 100, callback: { (path, thumbnail) in
                if file.path == path {
                    self.imageView.image = thumbnail
                }
                else {
                    print("Error:", path, file.path)
                }
            })
            break
        default:
            imageView.image = UIImage(named: file.type.iconName)
        }
    }
    
    var selectedFile = false {
        didSet {
            if selectedFile {
                editingImageView.image = UIImage(named: "icon-checkbox-y")
            }
            else {
                editingImageView.image = UIImage(named: "icon-checkbox-n")
            }
        }
    }
    
    var editing: Bool = false {
        didSet {
            editingImageView.hidden = !editing
        }
    }
    
    // MARK: - Lazy
    
    lazy var imageView: UIImageView = {
        let lazy = UIImageView()
        self.contentView.addSubview(lazy)
        return lazy
    }()
    
    lazy var nameLabel: UILabel = {
        let lazy = UILabel()
        lazy.font = Font(10)
        lazy.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(lazy)
        return lazy
    }()
    
    lazy var editingImageView: UIImageView = {
        let lazy = UIImageView()
        lazy.image = UIImage(named: "icon-checkbox-n")
        self.contentView.addSubview(lazy)
        return lazy
    }()
    
}
