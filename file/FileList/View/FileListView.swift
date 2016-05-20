//
//  FileListView.swift
//  file
//
//  Created by 翟泉 on 16/5/17.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit

protocol FileListViewDataSource: AnyObject {
    
    var editing: Bool {get set}
    
    func fileCount() -> Int
    
    func fileForIndex(index: Int) -> File
    
    func isSelectedForIndex(index: Int) -> Bool
    
    func selectFileAtIndex(index: Int)
    
}

extension FileListViewDataSource {
    var editing: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    func isSelectedForIndex(index: Int) -> Bool {
        return false
    }
    
    func selectFileAtIndex(index: Int) { }
    
}


//protocol PPPSX : AnyObject {
//    
//}

class FileListView: UIView  {
    
    weak var dataSource: FileListViewDataSource?
    
    
//    weak var weakDelegate: AnyObject where PPPSX
    
//    func aasas<T: AnyObject where T: PPPSX>(aaa: T) {
//        
//    }
    
    
    var ssscls: AnyObject?
    
    var tableView: UITableView!
    
    var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout!
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithTableView() {
        tableView?.removeFromSuperview()
        collectionView?.removeFromSuperview()
        collectionView = nil
        
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorInset  = UIEdgeInsetsZero
        tableView.layoutMargins   = UIEdgeInsetsZero
        tableView.registerClass(FileListTableViewCell.classForCoder(), forCellReuseIdentifier: "File")
        addSubview(tableView)
        
        if bounds != CGRectZero {
            setNeedsLayout()
        }
    }
    
    func initWithCollectionView() {
        tableView?.removeFromSuperview()
        collectionView?.removeFromSuperview()
        tableView = nil
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(FileCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "File")
        addSubview(collectionView)
        
        if bounds != CGRectZero {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        tableView?.frame = bounds
        collectionView?.frame = bounds
        
        if flowLayout != nil {
            let count = Int((frame.width-10) / (60+10))
            let width = Int((frame.width-10-CGFloat(count)*10) / CGFloat(count))
            flowLayout.itemSize = CGSizeMake(CGFloat(width), CGFloat(width)+14)
        }
        
        super.layoutSubviews()
    }
    
}


// MARK: - FileListViewModelDelegate
extension FileListView: FileListViewModelDelegate {
    func reloadAll() {
        if tableView != nil {
            tableView.reloadData()
        }
        else if collectionView != nil {
            collectionView.reloadData()
        }
    }
    
    func reloadAtIndexs(indexs: [Int]) {
        if tableView != nil {
            tableView.reloadRowsAtIndexPaths(indexPathsForIndexs(indexs), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        else if collectionView != nil {
            collectionView.reloadItemsAtIndexPaths(indexPathsForIndexs(indexs))
        }
    }
    
    func insertAtIndexs(indexs: [Int]) {
        if tableView != nil {
            tableView.insertRowsAtIndexPaths(indexPathsForIndexs(indexs), withRowAnimation: UITableViewRowAnimation.Left)
        }
        else if collectionView != nil {
            collectionView.insertItemsAtIndexPaths(indexPathsForIndexs(indexs))
        }
    }
    
    func removeAtIndexs(indexs: [Int]) {
        if tableView != nil {
            tableView.deleteRowsAtIndexPaths(indexPathsForIndexs(indexs), withRowAnimation: UITableViewRowAnimation.Right)
        }
        else if collectionView != nil {
            collectionView.deleteItemsAtIndexPaths(indexPathsForIndexs(indexs))
        }
    }
    
    func indexPathsForIndexs(indexs: [Int]) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        for index in indexs {
            indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
        }
        return indexPaths
    }
}

// MARK: - UITableView
extension FileListView: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dataSource != nil else {
            return 0
        }
        return dataSource!.fileCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("File") as! FileListTableViewCell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FileListTableViewCell.Height
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let fileCell = cell as? FileListTableViewCell else {
            return
        }
        guard dataSource != nil else {
            return
        }
        
        fileCell.layoutMargins = UIEdgeInsetsZero
        fileCell.setupData(dataSource!.fileForIndex(indexPath.row))
        fileCell.editing = dataSource!.editing
        if dataSource!.editing {
            fileCell.selectedFile = dataSource!.isSelectedForIndex(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard dataSource != nil else {
            return
        }
        dataSource!.selectFileAtIndex(indexPath.row)
    }
}

// MARK: - UICollectionView
extension FileListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard dataSource != nil else {
            return 0
        }
        return dataSource!.fileCount()
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("File", forIndexPath: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let fileCell = cell as? FileCollectionViewCell else {
            return
        }
        fileCell.setupData(dataSource!.fileForIndex(indexPath.row))
        fileCell.editing = dataSource!.editing
        if dataSource!.editing {
            fileCell.selectedFile = dataSource!.isSelectedForIndex(indexPath.row)
        }
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard dataSource != nil else {
            return
        }
        dataSource!.selectFileAtIndex(indexPath.row)
    }
}
