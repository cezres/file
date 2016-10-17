//
//  MusicPlayerBackgroudView.swift
//  file
//
//  Created by 翟泉 on 2016/10/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicPlayerBackgroudView: UIImageView {

    var url: URL? {
        didSet {
            if let url = url {
                image = UIImage(contentsOfFile: url.path)
            }
            else {
                
            }
        }
    }
    
    init() {
        super.init(frame: CGRect())
        
        clipsToBounds = true
        contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
        
        
        
//        let blurEffectView2 = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//        addSubview(blurEffectView2)
//        blurEffectView2.snp.makeConstraints { (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.top.equalTo(0)
//            make.height.equalTo(snp.height).multipliedBy(0.5)
//        }
//        
//        let blurEffectView3 = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        addSubview(blurEffectView3)
//        blurEffectView3.snp.makeConstraints { (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.top.equalTo(blurEffectView2.snp.bottom)
//            make.bottom.equalTo(snp.bottom).offset(0)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
