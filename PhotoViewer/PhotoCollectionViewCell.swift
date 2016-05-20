//
//  PhotoCollectionViewCell.swift
//  file
//
//  Created by 翟泉 on 16/5/19.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView
    
    var filePath: String = "" {
        didSet {
            imageView.image = nil
            let start1 = CACurrentMediaTime()
            PhotoCache.sharedInstance.imageForPath(filePath) { (filePath, image) in
                let end1 = CACurrentMediaTime()
                print("测量时间1：\(Float(end1 - start1))   ", filePath.photo_lastPathComponent)
                if filePath == self.filePath {
                    self.imageView.image = image
                                        self.setNeedsLayout()
                }
            }
            print("didSet",filePath.photo_lastPathComponent)
            let end2 = CACurrentMediaTime()
            print("测量时间2：\(Float(end2 - start1))   ", filePath.photo_lastPathComponent)

        }
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if let image = imageView.image {
            imageView.frame = CGRect(origin: CGPointZero, size: image.size)
            imageView.photo_centeringForSuperview()
        }
        super.layoutSubviews()
    }
    
    
}
