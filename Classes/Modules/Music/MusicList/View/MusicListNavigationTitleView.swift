//
//  MusicListNavigationTitleView.swift
//  file
//
//  Created by 翟泉 on 2016/10/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


class SubButton: UIButton {
    
    init() {
        super.init(frame: CGRect())
        setTitle("播放列表", for: .normal)
        setTitleColor(ColorWhite(46), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MusicListNavigationTitleView: UIControl {
    
    let block: (() -> Void)
    
    let titleLabel = UILabel()
    let imageView = UIImageView()

    init(title: String, touchUpInside block: @escaping (() -> Void)) {
        self.block = block
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = ColorWhite(46)
        titleLabel.text = title
        addSubview(titleLabel)
        
        let image = #imageLiteral(resourceName: "icon_arrow_down")
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorWhite(46)
        addSubview(imageView)
        
        
        let titleWidth = titleLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: 100, height: 20), limitedToNumberOfLines: 0).size.width
        let iconWidth: CGFloat = 20
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo((100-titleWidth-iconWidth) / 2)
            make.centerY.equalTo(0)
            make.width.equalTo(titleWidth)
            make.height.equalTo(20)
        }
        imageView.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.width.equalTo(iconWidth)
            make.centerY.equalTo(0)
            make.height.equalTo(iconWidth)
        })
        
        super.addTarget(self, action: #selector(MusicListNavigationTitleView.touchDown), for: UIControlEvents.touchDown)
        super.addTarget(self, action: #selector(MusicListNavigationTitleView.touchUpOutside), for: UIControlEvents.touchUpOutside)
        super.addTarget(self, action: #selector(MusicListNavigationTitleView.touchUpInside), for: UIControlEvents.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        fatalError("")
    }
    
    func touchDown() {
        titleLabel.textColor = ColorWhite(146)
        imageView.tintColor = ColorWhite(146)
    }
    func touchUpOutside() {
        titleLabel.textColor = ColorWhite(46)
        imageView.tintColor = ColorWhite(46)
    }
    func touchUpInside() {
        titleLabel.textColor = ColorWhite(46)
        imageView.tintColor = ColorWhite(46)
        block()
    }
    
    override var isSelected: Bool {
        set {
            super.isSelected = newValue
            print(newValue)
        }
        get {
            return super.isSelected
        }
    }

}
