//
//  FileListCollectionView.swift
//  file
//
//  Created by 翟泉 on 2016/6/28.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileListCollectionView: FileListView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: FileListViewDelegate!
    
    var flowLayout: UICollectionViewFlowLayout!
    
    var collectionView: UICollectionView!
    
    
    required init(delegate: FileListViewDelegate) {
        super.init(delegate: delegate)
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.itemSize = CGSize(width: 91, height: 120)
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FileCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "File")
        addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.delegate = delegate
    }
    
    override func reload() {
        collectionView.reloadData()
    }
    
    override func reload(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
    override func reload(indexs: [Int]) {
        var indexPaths = [IndexPath]()
        for idx in indexs {
            indexPaths.append(IndexPath(row: idx, section: 0))
        }
        collectionView.reloadItems(at: indexPaths)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "File", for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let fileCell = cell as? FileCollectionViewCell else {
            return
        }
        fileCell.setFileEntity(file: delegate.fileEntity(index: indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.selectedFile(index: indexPath.row)
    }
    
}
