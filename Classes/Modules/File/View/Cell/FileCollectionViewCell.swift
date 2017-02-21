//
//  FileCollectionViewCell.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class FileCollectionViewCell: UICollectionViewCell {
    
    
    
    
    
    var isEditing = false {
        didSet {
            chooseView.isHidden = !isEditing
        }
    }
    
    private var _isSelect = false
    
    var isSelect: Bool {
        get {
            return _isSelect
        }
        set {
            guard newValue != isSelect else {
                return
            }
            _isSelect = newValue
            if newValue {
                chooseView.image = #imageLiteral(resourceName: "icon_choose_y")
            }
            else {
                chooseView.image = #imageLiteral(resourceName: "icon_choose_n")
            }
        }
    }
    
    class func height(width: CGFloat) -> CGFloat {
        return width + UIFont.systemFont(ofSize: 12).lineHeight * 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.white
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = ColorWhite(220)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    var file: File! {
        didSet {
            guard file != oldValue else {
                return
            }
            setup()
        }
        
    }
    
    private func setup() {
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
    
    // MARK: - Get
    
    private lazy var iconImageView: ASImageView = {
        let imageView = ASImageView()
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
    private lazy var nameLabel: UILabel = {
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
    
    private lazy var chooseView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icon_choose_n")
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.equalTo(10)
            make.right.equalTo(-10)
        })
        return imageView
    }()
}
