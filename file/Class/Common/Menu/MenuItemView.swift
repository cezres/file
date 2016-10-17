//
//  MenuItemView.swift
//  file
//
//  Created by 翟泉 on 2016/10/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MenuItemView: ButtonCollectionViewCell {
    
    var textLabel: UILabel!
    var separatorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.white
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = ColorWhite(white: 220)
        
        textLabel = UILabel()
        textLabel.font = Font(16)
        textLabel.textAlignment = .center
        textLabel.textColor = ColorWhite(white: 34)
        contentView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        separatorView = UIView()
        separatorView.backgroundColor = ColorWhite(white: 220)
        addSubview(separatorView)
        
        separatorView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        let button = UIButton(type: .system)
        button.setTitle("删除", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ColorRGB(253, 85, 98)
        
        rightButtons = [button]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
