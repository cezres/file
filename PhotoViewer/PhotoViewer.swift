//
//  PhotoViewer.swift
//  file
//
//  Created by 翟泉 on 16/5/19.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

public class PhotoViewer: UIViewController {
    
    
    public var count: Int
    public var currentIndex: Int
    
    private var filePaths: [String]
    private var flowLayout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!
    
    public init(filePaths: [String], index: Int = 0) {
        
        currentIndex = index
        self.filePaths = filePaths
//        self.filePaths.insert(filePaths[0], atIndex: 0)
//        self.filePaths.append(filePaths[filePaths.count-1])
        count = self.filePaths.count
        super.init(nibName: nil, bundle: nil)
        
//        filePaths.removeFirst()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        view.backgroundColor = UIColor.whiteColor()
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.pagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(PhotoCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Photo")
        view.addSubview(collectionView)
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        PhotoCache.sharedInstance.removeAllCache()
    }
    
    public override func viewWillLayoutSubviews() {
        if view.bounds.width > view.bounds.height {
            collectionView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height-44)
        }
        else {
            collectionView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height-64)
        }
        flowLayout.itemSize = CGSizeMake(collectionView.frame.width, collectionView.frame.height)
        
        collectionView.contentOffset = CGPointMake(collectionView.frame.width * CGFloat(currentIndex), 0)
        
        super.viewWillLayoutSubviews()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        PhotoCache.sharedInstance.removeAllCache()
    }
    
}

// MARK: - UICollectionView-Protocol
extension PhotoViewer: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.contentOffset.x > CGFloat(currentIndex+1) * scrollView.frame.width {
//            currentIndex += 1
//        }
//        else if scrollView.contentOffset.x < CGFloat(currentIndex-1) * scrollView.frame.width {
//            currentIndex -= 1
//        }
        if scrollView.tag != Int(scrollView.frame.width) {
            scrollView.tag = Int(scrollView.frame.width)
            return
        }
        
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        title = "\(currentIndex+1)/\(count)"
    }
    // MARK: UICollectionViewDataSource
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("Photo", forIndexPath: indexPath)
    }
    // MARK: UICollectionViewDelegate
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let photo = cell as? PhotoCollectionViewCell else {
            return
        }
        print(indexPath)
        
        photo.filePath = filePaths[indexPath.row]
        
//        currentIndex = indexPath.row
        
//        title = "\(currentIndex+1)/\(count)"
        
        if indexPath.row - 1 >= 0 {
            PhotoCache.sharedInstance.loadImage(filePaths[indexPath.row-1])
        }
        if indexPath.row + 1 < filePaths.count {
            PhotoCache.sharedInstance.loadImage(filePaths[indexPath.row+1])
        }
    }
}
