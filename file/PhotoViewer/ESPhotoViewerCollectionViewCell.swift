//
//  ESPhotoViewerCollectionViewCell.swift
//  ESPhotoViewer
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit






public class ESPhotoViewerCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    var item = ESPhotoItem()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: frame)
        addSubview(imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        
        if let image = imageView.image {
            imageView.frame = CGRect(origin: CGPointZero, size: image.size)
            imageView.es_centeringForSuperview()
        }
        
        super.layoutSubviews()
    }
    
    public func setImageURL(url: NSURL) {
        
        imageView.image = nil
        
        item.url = url
        
        item.getImage { (image) in
            self.imageView.image = image
            self.setNeedsLayout()
        }
    }
}


