//
//  FileListViewProtocol.swift
//  file
//
//  Created by 翟泉 on 2016/6/28.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


protocol FileListViewDelegate: NSObjectProtocol {
    
    func count() -> Int
    
    func fileEntity(index: Int) -> FileEntity
    
    func selectedFile(index: Int)
    
}

protocol FileListViewProtocol {
    
    init(delegate: FileListViewDelegate)
    
    func reload()
    
    func reload(index: Int)
    
    func reload(indexs: [Int])
    
    func setEditing(editing: Bool)
    
    func isEditing() -> Bool
    
    func selectedItems() -> [Int]
    
    func select(idx: Int)
    
    func selectAll()
    
    func cancelSelectAll()
    
}

class FileListView: UIView, FileListViewProtocol {
    
    weak var delegate: FileListViewDelegate!
    
    required init(delegate: FileListViewDelegate) { super.init(frame: CGRect()); self.delegate = delegate }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func reload() {}
    
    func reload(index: Int) {}
    
    func reload(indexs: [Int]) {}
    
    func setEditing(editing: Bool) {}
    
    func isEditing() -> Bool { return false }
    
    func selectedItems() -> [Int] { return [] }
    
    func select(idx: Int) {}
    
    func selectAll() {}
    
    func cancelSelectAll() {}
    
}









