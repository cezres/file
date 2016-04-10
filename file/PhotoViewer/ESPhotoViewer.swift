//
//  ESPhotoViewer.swift
//  ESPhotoViewer
//
//  Created by cezr on 16/4/3.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit

public protocol ESPhotoViewerDelegate: NSObjectProtocol {
    func photoViewer(photoViewer: ESPhotoViewer, didSelectPhoto item: ESPhotoItem)
    func photoViewer(photoViewer: ESPhotoViewer, didMoveToIndex index: Int)
}
extension ESPhotoViewerDelegate {
    func photoViewer(photoViewer: ESPhotoViewer, didSelectPhoto item: ESPhotoItem) {}
    func photoViewer(photoViewer: ESPhotoViewer, didMoveToIndex index: Int) {}
}

public class ESPhotoViewer: UIView {
    
    public var imageSource = [NSURL]()
    
    public var currentIndex: Int = 0 {
        didSet {
            
            delegate?.photoViewer(self, didMoveToIndex: currentIndex)
            
            guard collectionView.contentSize != CGSizeZero else {
                return
            }
            guard collectionView.contentOffset.x / collectionView.frame.size.width != CGFloat(currentIndex) else {
                return
            }
            collectionView.contentOffset = CGPoint(x: collectionView.frame.width * CGFloat(currentIndex), y: 0)
        }
    }
    
    public weak var delegate: ESPhotoViewerDelegate?
    
    private var collectionView: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!
    
    
    
    public init() {
        super.init(frame: CGRectZero)
        initializationSubViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializationSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializationSubViews() {
        
        flowLayout                   = UICollectionViewFlowLayout()
        flowLayout.scrollDirection   = UICollectionViewScrollDirection.Horizontal

        collectionView               = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate      = self
        collectionView.dataSource    = self
        collectionView.pagingEnabled = true
        
        collectionView.registerClass(ESPhotoViewerCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Item")
        
        self.addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard collectionView.frame.size != bounds.size else {
            return
        }
        
        collectionView.delegate = nil
        
        collectionView.frame               = CGRect(origin: CGPointZero, size: bounds.size)
        flowLayout.itemSize                = CGSize(width: frame.width, height: frame.height/* - 64 - 49*/)
        flowLayout.minimumLineSpacing      = 0
        flowLayout.minimumInteritemSpacing = 0
        
//        let index = currentIndex
//        self.currentIndex = index
        guard collectionView.contentOffset.x / collectionView.frame.size.width != CGFloat(currentIndex) else {
            collectionView.delegate = self
            return
        }
        collectionView.contentOffset = CGPoint(x: collectionView.frame.width * CGFloat(currentIndex), y: 0)
        
//        delegate?.photoViewer(self, didMoveToIndex: currentIndex)
        
        collectionView.delegate = self
        
        
    }
    
}


extension ESPhotoViewer: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > CGFloat(currentIndex+1) * scrollView.frame.width {
            currentIndex += 1
        }
        else if scrollView.contentOffset.x < CGFloat(currentIndex-1) * scrollView.frame.width {
            currentIndex -= 1
        }
    }
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard currentIndex != Int(scrollView.contentOffset.x / scrollView.frame.size.width) else {
            return
        }
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
        
        if let photoCell = cell as? ESPhotoViewerCollectionViewCell {
            photoCell.setImageURL(imageSource[indexPath.row])
            photoCell.item.index = indexPath.row
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let photoCell = collectionView.cellForItemAtIndexPath(indexPath) as? ESPhotoViewerCollectionViewCell {
            delegate?.photoViewer(self, didSelectPhoto: photoCell.item)
        }
    }
}

extension ESPhotoViewer: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSource.count
    }
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("Item", forIndexPath: indexPath)
    }
    
}

