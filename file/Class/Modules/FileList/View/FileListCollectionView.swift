//
//  FileListCollectionView.swift
//  file
//
//  Created by 翟泉 on 2016/6/28.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileListCollectionView: FileListView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var flowLayout: UICollectionViewFlowLayout!
    
    var collectionView: UICollectionView!
    
    private var editing: Bool = false
    
    private var selected = [Bool]()
    
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
    
    override func setEditing(editing: Bool) {
        self.editing = editing
        
        
        selected.removeAll()
        if self.editing {
            for _ in 0..<delegate.count() {
                selected.append(false)
            }
        }
        else {
            
        }
        
        collectionView.reloadData()
    }
    
    override func isEditing() -> Bool {
        return editing
    }
    
    override func selectedItems() -> [Int] {
        var items = [Int]()
        for (idx,value) in selected.enumerated() {
            if value {
                items.append(idx)
            }
        }
        return items
    }
    
    override func select(idx: Int) {
        selected[idx] = !selected[idx]
        collectionView.reloadItems(at: [IndexPath(row: idx, section: 0)])
    }
    
    override func selectAll() {
        for idx in 0..<selected.count {
            if !selected[idx] {
                selected[idx] = true
            }
        }
        collectionView.reloadData()
    }
    
    override func cancelSelectAll() {
        for idx in 0..<selected.count {
            if selected[idx] {
                selected[idx] = false
            }
        }
        collectionView.reloadData()
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
        fileCell.editing = editing
        if editing {
            fileCell._selected = selected[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editing {
            selected[indexPath.row] = !selected[indexPath.row]
            guard let cell = collectionView.cellForItem(at: indexPath) as? FileCollectionViewCell else {
                return
            }
            cell._selected = selected[indexPath.row]
        }
        else {
            delegate.selectedFile(index: indexPath.row)
        }
    }
    
}
