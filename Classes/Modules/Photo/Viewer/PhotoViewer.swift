//
//  PhotoViewer.swift
//  file
//
//  Created by 翟泉 on 2017/2/15.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoViewer: UIViewController/*, ASCollectionDataSource, ASCollectionDelegate, ASCollectionViewLayoutInspecting*/ {
    
    var _urls: [URL]!
    var _collectionNode: ASCollectionNode!
    var _collectionView: UICollectionView!
    var _idx = 0
    
    init(urls: [URL], idx: Int) {
        super.init(nibName: nil, bundle: nil)
        _urls = urls
        _idx = idx
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        /*
        _collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: flowLayout)
        _collectionNode.delegate = self
        _collectionNode.dataSource = self
        _collectionNode.view.layoutInspector = self
        //_collectionNode.view.isPagingEnabled = true
        _collectionNode.backgroundColor = UIColor.gray
        _collectionNode.view.isScrollEnabled = true
        view.addSubnode(_collectionNode)
        */
        
        _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.backgroundColor = UIColor.white
        _collectionView.isScrollEnabled = true
        _collectionView.isPagingEnabled = true
        _collectionView.register(PhotoCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Photo")
        view.addSubview(_collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _collectionView.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64)
        _collectionView.contentOffset = CGPoint(x: _collectionView.bounds.width * CGFloat(_idx), y: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return PhotoCellNode(url: _urls[indexPath.row])
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return _urls.count
    }
    
    func scrollableDirections() -> ASScrollDirection {
        return ASScrollDirectionVerticalDirections
    }
    
    func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(min: CGSize.zero, max: collectionView.bounds.size)
    }*/

}


extension PhotoViewer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCollectionViewCell
        photoCell.url = _urls[indexPath.row]
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}
