//
//  PhotoViewer.swift
//  file
//
//  Created by 翟泉 on 2016/6/30.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class PhotoViewer: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    
    var photoItems = [PhotoItem]()
    
    var imagePaths: [String]!
    
    var currentIndex: Int = 0 {
        didSet {
            didSetCurrentIndex(oldIndex: oldValue)
        }
    }
    
    internal init(imagePaths: [String], index: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.imagePaths = imagePaths
        currentIndex = index
        title = "\(currentIndex+1)/\(imagePaths.count)"
        view.backgroundColor = UIColor.white()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(classForCoder)
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        
        let rect: CGRect
        if view.frame.width < view.frame.height {
            rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height-20)
        }
        else {
            rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }
        
        scrollView = UIScrollView(frame: rect)
        scrollView.backgroundColor = view.backgroundColor
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(imagePaths.count), height: scrollView.bounds.height)
        scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(currentIndex), y: 0)
        
        let count = imagePaths.count > 5 ? 5 : imagePaths.count
        for idx in 0..<count {
            let offset: Int
            if currentIndex > imagePaths.count-2 {
                offset = imagePaths.count - count
            }
            else if currentIndex < 2 {
                offset = 0
            }
            else {
                offset = currentIndex - 2
            }
            let index = offset + idx
            
            let frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            let item = PhotoItem(frame: frame)
            photoItems.append(item)
            scrollView.addSubview(item)
            
            
            item.imagePath = imagePaths[index]
        }
        
        addGestureRecognizer()
    }
    
    
    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoViewer.handleTapGesture(tapGesture:)))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        navigationController?.navigationBar.isHidden = !navigationController!.navigationBar.isHidden
    }
    
    
    
    internal override func viewWillLayoutSubviews() {
        
        layoutSubviews()
        
        super.viewWillLayoutSubviews()
    }
    
    func layoutSubviews() {
        let rect: CGRect
        if view.frame.width < view.frame.height {
            rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height-20)
        }
        else {
            rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }
        
        if rect != scrollView.frame {
            
            scrollView.frame = rect
            scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(imagePaths.count), height: scrollView.bounds.height)
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(currentIndex), y: 0)
            
            for (idx, item) in photoItems.enumerated() {
                
                
                let offset: Int
                if currentIndex > imagePaths.count-2 {
                    offset = imagePaths.count - photoItems.count
                }
                else if currentIndex < 2 {
                    offset = 0
                }
                else {
                    offset = currentIndex - 2
                }
                
                let index = CGFloat(offset + idx)
                
                print(index)
                
                item.frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            }
        }
        
    }
    
    func didSetCurrentIndex(oldIndex: Int) {
        title = "\(currentIndex+1)/\(imagePaths.count)"
        
        print(currentIndex)
        
        if currentIndex < 2 || currentIndex > imagePaths.count-3 {
            return
        }
        
        if currentIndex > oldIndex {
            if currentIndex == 2 {
                return
            }
            let item = photoItems.removeFirst()
            photoItems.append(item)
            let offset = CGFloat(currentIndex + 2) * scrollView.frame.width - item.frame.origin.x
            item.transform = item.transform.translateBy(x: offset, y: 0)
            item.imagePath = imagePaths[currentIndex + 2]
        }
        else if currentIndex < oldIndex {
            if currentIndex == imagePaths.count-3 {
                return
            }
            let item = photoItems.removeLast()
            photoItems.insert(item, at: 0)
            
            let offset = CGFloat(currentIndex - 2) * scrollView.frame.width - item.frame.origin.x
            item.transform = item.transform.translateBy(x: offset, y: 0)
            item.imagePath = imagePaths[currentIndex - 2]
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > CGFloat(currentIndex+1) * scrollView.frame.width {
            currentIndex += 1
        }
        else if scrollView.contentOffset.x < CGFloat(currentIndex-1) * scrollView.frame.width {
            currentIndex -= 1
        }
    }
    
}
