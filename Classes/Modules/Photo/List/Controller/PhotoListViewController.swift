//
//  PhotoListViewController.swift
//  file
//
//  Created by 翟泉 on 2017/2/18.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Photos
import RESideMenu

class PhotoListViewController: UIViewController {
    
    var photoAssets: PHFetchResult<PHAsset>!
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "照片列表"
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        print(navigationController?.navigationBar.frame)
        
        guard collectionView != nil else {
            return
        }
        let frame = navigationController?.navigationBar.frame
        collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(frame!.maxY)
        }
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PHPhotoLibrary.requestAuthorization { (status) in
            self.reloadPHAsset()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        guard navigationController?.sideMenuViewController == nil else {
            return
        }
        photoAssets = nil
        collectionView.removeFromSuperview()
        collectionView = nil
    }
    
    func reloadPHAsset() {
        if PHPhotoLibrary.authorizationStatus() == .restricted ||
            PHPhotoLibrary.authorizationStatus() == .denied {
            print("无相册访问权限")
            return
        }
        let creationDate = NSSortDescriptor(key: "creationDate", ascending: true)
        let option = PHFetchOptions()
        option.sortDescriptors = [creationDate]
        photoAssets = PHAsset.fetchAssets(with: .image, options: option)
        OperationQueue.main.addOperation {
            self.initCollectionView()
            self.collectionView.reloadData()
        }
    }
    
    func initCollectionView() {
        guard collectionView == nil else {
            return
        }
        let layout = PhotoFlowLayout()
        layout.numberOfColumns = 3
        layout.interItemSpacing = UIEdgeInsetsMake(5, 0, 5, 0)
        layout._sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.columnSpacing = 5
        layout.headerHeight = 0
        layout.delegate = self
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(PhotoCell.classForCoder(), forCellWithReuseIdentifier: "Photo")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64)
            make.bottom.equalTo(0)
        }
    }
    
    fileprivate var targetRect = CGRect.zero
    fileprivate var userDragging = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        debugPrint("将要开始拖动")
        userDragging = true
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        debugPrint("将要结束拖动")
        userDragging = false
        targetRect = CGRect(origin: targetContentOffset.pointee, size: scrollView.bounds.size)
//        debugPrint(targetContentOffset.pointee)
    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        debugPrint("结束拖动", "\t拖动:\(scrollView.isDragging) 减速:\(scrollView.isDecelerating)")
//        if !scrollView.isDragging {
//            debugPrint("加载")
//        }
//    }
    
    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        debugPrint("将要开始减速")
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        debugPrint("结束减速", "\t拖动:\(scrollView.isDragging) 减速:\(scrollView.isDecelerating)")
//        debugPrint("加载")
//    }
    
}


extension PhotoListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PhotoFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (photoAssets != nil) ? photoAssets.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCell
        cell.asset = photoAssets[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? PhotoCell else { return }
        if !collectionView.isDragging && !collectionView.isDecelerating {
            debugPrint("原图-静止状态")
            photoCell.opportunistic()
        }
        else if userDragging {
            debugPrint("原图-用户正在拖动")
            photoCell.opportunistic()
        }
        else if targetRect.intersects(cell.frame) {
            debugPrint("原图-在滚动停止的范围内")
            photoCell.opportunistic()
        }
        else {
            debugPrint("缩略图-不在滚动停止的范围内")
            photoCell.fastFormat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! PhotoFlowLayout
        let itemSize = layout._itemSizeAtIndexPath(indexPath: indexPath)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: PhotoFlowLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        let asset = photoAssets[originalItemSizeAtIndexPath.row]
        return CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(collectionView.contentOffset)
//    }
    
    
}
