//
//  AppLaunchView.swift
//  file
//
//  Created by 翟泉 on 2016/7/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class AppLaunchView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init() {
        super.init(frame: UIScreen.main().bounds)
        backgroundColor = UIColor.white()
        
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = UIImage(named: "36490337_p0.jpg")
        addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        imageView.alpha = 0
        UIView.animate(withDuration: 2, animations: { 
            imageView.alpha = 1
            }) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.alpha = 0
                    }, completion: { (_) in
                        self.removeFromSuperview()
                })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show() {
        UIApplication.shared().keyWindow?.addSubview(AppLaunchView())
    }
    

}
