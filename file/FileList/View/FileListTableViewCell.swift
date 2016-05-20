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
    
    static let Height: CGFloat = 44
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        editingImageView.snp_makeConstraints { (make) in
            make.left.equalTo(-30)
            make.size.equalTo(CGSizeMake(30, 30))
            make.centerY.equalTo(0)
        }
        
        iconImageView.snp_makeConstraints { (make) in
            make.left.equalTo(editingImageView.snp_right).offset(10)
            make.size.equalTo(CGSizeMake(30, 30))
            make.centerY.equalTo(0)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(10)
            make.right.equalTo(0)
            make.height.equalTo(14)
            make.bottom.equalTo(self.contentView.snp_centerY).offset(-2)
        }
        
        descriptionLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(0)
            make.top.equalTo(self.contentView.snp_centerY).offset(2)
            make.height.equalTo(12)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(file: File) {
        self.file                  = file
        self.nameLabel.text        = file.lastPathComponent
        self.descriptionLabel.text = file.description
        
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
    
    override var editing: Bool {
        get {
            return super.editing
        }
        set {
            super.editing = newValue
            let offset: CGFloat
            if newValue {
                offset = 10
            }
            else {
                offset = -30
            }
            editingImageView.snp_updateConstraints(closure: { (make) in
                make.left.equalTo(offset)
            })
        }
    }
    
    
    
    lazy var iconImageView: UIImageView = {
        let lazy = UIImageView()
        self.contentView.addSubview(lazy)
        return lazy
    }()
    
    lazy var nameLabel: UILabel = {
        let lazy  = UILabel()
        lazy.font = Font(12)
        self.contentView.addSubview(lazy)
        return lazy
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lazy  = UILabel()
        lazy.font = Font(10)
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
