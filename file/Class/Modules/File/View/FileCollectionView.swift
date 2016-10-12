//
//  FileCollectionView.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


class FileCollectionView: UICollectionView, FileContentViewProtocol {
    
    
    weak var fileDataSource: FileContentViewDataSource!
    weak var fileDelegate: FileContentViewDelegate!
    
    
    // MARK: - FileViewProtocol
    
    required init(fileDataSource: FileContentViewDataSource, fileDelegate: FileContentViewDelegate) {
        self.fileDataSource = fileDataSource
        self.fileDelegate = fileDelegate
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        
        super.init(frame: CGRect(), collectionViewLayout: flowLayout)
        
        backgroundColor = UIColor.white
        dataSource = self
        delegate = self
        register(FileCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "File")
    }
    
    func reload() {
        reloadData()
    }
    
    func reloadItem(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = cellForItem(at: indexPath) {
            collectionView(self, willDisplay: cell, forItemAt: indexPath)
        }
    }
    
    func reloadItems(indexs: [Int]) {
        for idx in indexs {
            reloadItem(index: idx)
        }
    }
    
    func reloadAllItems() {
        for cell in visibleCells {
            if let indexPath = indexPath(for: cell) {
                collectionView(self, willDisplay: cell, forItemAt: indexPath)
            }
        }
    }
    
    func deleteItems(indexs: [Int]) {
        var indexPaths = [IndexPath]()
        for idx in indexs {
            let indexPath = IndexPath(row: idx, section: 0)
            indexPaths.append(indexPath)
        }
        deleteItems(at: indexPaths)
    }
    

    var flowLayout = UICollectionViewFlowLayout()
    
    var selectFile: ((_ file: File) -> Void)?
    
    init() {
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        
        super.init(frame: CGRect(), collectionViewLayout: flowLayout)
        
        backgroundColor = UIColor.white
        dataSource = self
        delegate = self
        register(FileCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "File")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FileCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - Number
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileDataSource.list().count
    }
    
    // MARK: - Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let number: CGFloat = 4
        let width = (collectionView.width-(number+1)*10) / 4
        return CGSize(width: width, height: FileCollectionViewCell.height(width: width))
    }
    
    // MARK: - Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "File", for: indexPath) as! FileCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let fileCell = cell as? FileCollectionViewCell else {
            return
        }
        fileCell.file = fileDataSource.list()[indexPath.row]
        fileCell.isEditing = fileDataSource.isEditing()
        if fileDataSource.isEditing() {
            fileCell.isSelect = fileDataSource.isSelected(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
        fileDelegate.fileView(fileView: self, didSelectIndex: indexPath.row)
    }
    
}
