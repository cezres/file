//
//  PhotoCollectionViewCell.swift
//  file
//
//  Created by 翟泉 on 2017/2/15.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //let imageView = UIImageView()
    
    let imageNode = ASImageNode()
    
    
    var url: URL! {
        didSet {
            imageNode.image = nil
            
            OperationQueue().addOperation { [weak self] in
                guard self != nil else {
                    return
                }
                if let image = PhotoMemoryCache.shared().object(forKey: self!.url.path) as? UIImage {
                    self!.imageNode.image = image
                    print("缓存: \(self!.url.lastPathComponent)")
                }
                else {
                    if let image = UIImage(contentsOfFile: self!.url.path) {
                        self!.imageNode.image = image
                        PhotoMemoryCache.shared().setObject(image, forKey: self!.url.path)
                        print("硬盘: \(self!.url.lastPathComponent)")
                    }
                }
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageNode.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubnode(imageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageNode.frame = bounds
    }
    
    
    
    
}
