//
//  MenuItemView.swift
//  file
//
//  Created by 翟泉 on 2016/10/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MenuItemView: ButtonTableViewCell {
    
    var separatorView: UIView!
    
    var item: MenuItem! {
        didSet {
            backgroundColor = item.backgroundColor
            
            textLabel?.text = item.title
            textLabel?.textColor = item.textColor
            
            separatorView.isHidden = item.isHiddenSeparatorView
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textAlignment = .center
        
        separatorView = UIView()
        separatorView.backgroundColor = ColorWhite(220)
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
        setRightButtons([button], withButtonWidth: 80)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
