//
//  ESPhotoViewerViewController.swift
//  file
//
//  Created by 翟泉 on 16/4/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class ESPhotoViewerViewController: UIViewController, ESPhotoViewerDelegate {
    
    let photoViewer = ESPhotoViewer()
    
//    var imageSource = [NSURL]()
    
    init(urls: [NSURL], selectedIndex: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        photoViewer.delegate        = self
//        imageSource                 = urls
        photoViewer.imageSource     = urls
        photoViewer.currentIndex    = selectedIndex
        photoViewer.backgroundColor = UIColor.grayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor        = UIColor.grayColor()
        
        
        view.addSubview(UIView())
        view.addSubview(photoViewer)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if view.frame.width < view.frame.height {
            photoViewer.frame = CGRectMake(0, 64, view.frame.width, view.frame.height - 64)
        }
        else {
            photoViewer.frame = CGRectMake(0, navigationController!.navigationBar.frame.size.height, view.frame.width, view.frame.height - 64)
        }
        
        
    }
    
    
    
    // MARK: - ESPhotoViewerDelegate
    func photoViewer(photoViewer: ESPhotoViewer, didSelectPhoto item: ESPhotoItem) {
        print(item.index)
    }
    func photoViewer(photoViewer: ESPhotoViewer, didMoveToIndex index: Int) {
        title = "\(index+1)/\(photoViewer.imageSource.count)"
    }

}
