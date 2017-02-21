//
//  PhotoCell.swift
//  file
//
//  Created by 翟泉 on 2017/2/20.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    let imageNode = ASImageNode()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubnode(self.imageNode)
        imageNode.contentMode = UIViewContentMode.scaleAspectFit
        backgroundColor = UIColor.white
        print(#function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageNode.frame = bounds
    }
    
    var asset: PHAsset? {
        didSet {
            imageNode.image = nil
            
            guard let asset = self.asset else {
                return
            }
            
            let option = PHImageRequestOptions()
            option.resizeMode = .fast
            option.isNetworkAccessAllowed = true
            option.version = .current
            option.deliveryMode = .opportunistic
            let imageWidth: CGFloat = 150 * UIScreen.main.scale
            let targetSize = CGSize(width: imageWidth, height: imageWidth / CGFloat(asset.pixelWidth) * CGFloat(asset.pixelHeight))
            PHCachingImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: option) { [weak self](image, _) in
                guard self?.asset == asset else {
                    return
                }
                self?.imageNode.image = image
//                print(asset.value(forKey: "filename") ?? "Null", "\t",  image!.size)
            }
        }
    }
    
}
