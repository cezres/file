//
//  FileListViewProtocol.swift
//  file
//
//  Created by 翟泉 on 2016/6/28.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

protocol FileListViewProtocol {
    
//    var editing: Bool {get set}
    
//    var selectedStates: [Bool] {get set}
    
    init(delegate: FileListViewDelegate)
    
    func reload()
    
    func reload(index: Int)
    
    func reload(indexs: [Int])
    
    
    
}

class FileListView: UIView, FileListViewProtocol {
    
    required init(delegate: FileListViewDelegate) { super.init(frame: CGRect()) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func reload() {}
    
    func reload(index: Int) {}
    
    func reload(indexs: [Int]) {}
    
}


protocol FileListViewDelegate: NSObjectProtocol {
    
    func count() -> Int
    
    func fileEntity(index: Int) -> FileEntity
    
    func selectedFile(index: Int)
    
}






