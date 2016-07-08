//
//  MusicBackgroundView.swift
//  file
//
//  Created by 翟泉 on 2016/7/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicBackgroundView: UIView {
    
    
    let imagePaths = [
        "50276332_p0.png",
//        "36490337_p0.jpg",
        "42826426_p0.png",
//        "46692022_p0.png",
        "53983444_p0.png",
//        "55842346_p0.png",
        "56508748_p0.png",
        "48269530_p0.png",
    ]
    
    let duration: TimeInterval = 10
    
    var currentIndex = 0
    
    var imageView = UIImageView()
    
    init() {
        super.init(frame: CGRect())
        
        currentIndex = 2
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNext() {
        
        currentIndex = currentIndex+1 == imagePaths.count ? 0 : currentIndex + 1
        
        let tempView = UIImageView()
        tempView.contentMode = UIViewContentMode.scaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = imageView.image
        addSubview(tempView)
        tempView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        imageView.image = UIImage(named: imagePaths[currentIndex])
        imageView.alpha = 0
        UIView.animate(withDuration: 1, animations: { 
            tempView.alpha = 0
            self.imageView.alpha = 1
            }) { (_) in
                tempView.removeFromSuperview()
        }
        
    }
    
}
