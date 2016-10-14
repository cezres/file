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
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
