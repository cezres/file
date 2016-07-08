//
//  PhotoItem.swift
//  file
//
//  Created by 翟泉 on 2016/6/30.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class PhotoItem: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var imageView: UIImageView!
    
    var scrollView: UIScrollView!
    
    var imagePath: String! {
        didSet {
//            imageView.image = nil
            guard imagePath != nil else {
                return
            }
            
            scrollView.contentSize = CGSize()
            
            LoadImageManager.manager.loadImage(imagePath: imagePath) { [weak self](path, image) in
                guard self != nil else {
                    return
                }
                guard path == self!.imagePath else {
                    return
                }
                self!.imageView.image = image
                self!.imageView.photo_centeringForSuperview()
                
                print(self!.imageView.image!.size.centerMaxScale(superSize: self!.scrollView.frame.size))
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white()
        scrollView = UIScrollView()
        scrollView.backgroundColor = backgroundColor
        addSubview(scrollView)
        imageView = UIImageView(frame: frame)
        scrollView.addSubview(imageView)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(PhotoItem.handlePinchGesture(pinchGesture:)))
        scrollView.addGestureRecognizer(pinchGesture)
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoItem.handleDoubleTapGesture(doubleTapGesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
    }
    
    func handlePinchGesture(pinchGesture: UIPinchGestureRecognizer) {
        print(pinchGesture.scale)
    }
    
    func handleDoubleTapGesture(doubleTapGesture: UITapGestureRecognizer) {
        print("DoubleTapGesture")
        guard imageView.image != nil else {
            return
        }
        if scrollView.contentSize.width > scrollView.frame.size.width || scrollView.contentSize.height > scrollView.frame.size.height {
            scrollView.contentSize = CGSize()
            imageView.photo_centeringForSuperview()
            scrollView.contentOffset = CGPoint()
        }
        else {
            scrollView.contentSize = imageView.image!.size
            imageView.frame = imageView.image!.size.centerMaxScale(superSize: scrollView.contentSize)
            scrollView.contentOffset = scrollView.contentSize.centerPoint(contentSize: scrollView.frame.size)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        defer {
            super.layoutSubviews()
        }
        guard scrollView.frame != bounds else {
            return
        }
        scrollView.frame = bounds
        imageView.photo_centeringForSuperview()
    }

}


extension CGSize {
    
    /*
     居中最大缩放
    */
    func centerMaxScale(superSize size: CGSize) -> CGRect {
        let newHeight = size.width * height / width
        if newHeight < size.height {
            return CGRect(x: 0, y: (size.height-newHeight) / 2, width: size.width, height: newHeight)
        }
        else {
            let newWidth = size.height * width / height
            return CGRect(x: (size.width-newWidth) / 2, y: 0, width: newWidth, height: size.height)
        }
    }
    
    /*
     居中的位置
     
    */
    func centerPoint(contentSize size: CGSize) -> CGPoint {
        
        return CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        
    }
    
}
