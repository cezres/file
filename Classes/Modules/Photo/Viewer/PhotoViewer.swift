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
    
    fileprivate var _urls: [URL]!
    
    
    
    fileprivate var _collectionView: UICollectionView!
    fileprivate var _scrollView: UIScrollView!
    
    init(urls: [URL], idx: Int) {
        super.init(nibName: nil, bundle: nil)
        _urls = urls
        index = idx
        title = "\(index+1)/\(_urls.count)"
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
        
        _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.backgroundColor = UIColor.white
        _collectionView.isScrollEnabled = true
        _collectionView.isPagingEnabled = true
        _collectionView.register(PhotoCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Photo")
        view.addSubview(_collectionView)
 
        
//        loadPhoto(index: 0)
        
//        _scrollView = UIScrollView()
//        _scrollView.isPagingEnabled = true
//        _scrollView.delegate = self
//        _scrollView.backgroundColor = UIColor.orange
//        view.addSubview(_scrollView)
//        _scrollView.snp.makeConstraints { (make) in
//            make.edges.equalTo(view)
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _collectionView.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64)
        _collectionView.contentOffset = CGPoint(x: _collectionView.bounds.width * CGFloat(index), y: 0)
//        let topOffset = navigationController?.navigationBar.frame.maxY ?? 0
//        _scrollView.snp.updateConstraints { (make) in
//            make.top.equalTo(view.snp.top).offset(topOffset)
//        }
//        _scrollView.layoutIfNeeded()
//        _scrollView.contentSize = CGSize(width: _scrollView.bounds.width * CGFloat(_urls.count), height: _scrollView.bounds.height)
//        _scrollView.contentOffset = CGPoint(x: _scrollView.bounds.width * CGFloat(index), y: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    fileprivate var photoViews = [PhotoView]()
    fileprivate var cachePhotoViews = [PhotoView]()
    
    fileprivate var cells = [PhotoCollectionViewCell]()
    
    fileprivate var index: Int = 0 {
        didSet {
            guard index != oldValue else {
                return
            }
            title = "\(index+1)/\(_urls.count)"
            
            
            
        }
    }
    
    let imageView = ASImageView()
    let imageView2 = ASImageView()
    
    func loadPhoto(index: Int) {
//        let cell = _collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: IndexPath(row: index, section: 0)) as! PhotoCollectionViewCell
//        cell.url = _urls[index]
//        cells.append(cell)
        
        imageView.image = UIImage(contentsOfFile: _urls[1].path)
        
        imageView.frame = CGRect(origin: CGPoint(x: 600, y: 0), size: view.bounds.size)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        imageView2.image = UIImage(contentsOfFile: _urls[0].path)
        imageView2.frame = CGRect(origin: CGPoint(x: 600, y: 0), size: view.bounds.size)
        imageView2.contentMode = .scaleAspectFit
        view.addSubview(imageView2)
    }

}


extension PhotoViewer: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func prepareForInterfaceBuilder() {
//        _collectionView.refreshControl
//        _collectionView.isPrefetchingEnabled
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCollectionViewCell
        photoCell.url = _urls[indexPath.row]
        
//        if indexPath.row % 2 == 0 {
//            photoCell.addSubview(imageView)
//            imageView.snp.makeConstraints { (make) in
//                make.edges.equalTo(photoCell)
//            }
//        }
//        else {
//            photoCell.addSubview(imageView2)
//            imageView2.snp.makeConstraints { (make) in
//                make.edges.equalTo(photoCell)
//            }
//        }
        
        
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > CGFloat(index+1) * scrollView.frame.width {
            index += 1
        }
        else if scrollView.contentOffset.x < CGFloat(index-1) * scrollView.frame.width {
            index -= 1
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard index != Int(scrollView.contentOffset.x / scrollView.frame.size.width) else {
            return
        }
        index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
}
