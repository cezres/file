//
//  FileContentViewProtocol.swift
//  file
//
//  Created by 翟泉 on 2016/9/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


protocol FileContentViewDataSource: NSObjectProtocol {
    
    /// 文件列表
    func list() -> [File]
    
    /// 是否在编辑状态
    func isEditing() -> Bool
    
    /// 是否是选中状态
    func isSelected(index: Int) -> Bool
    
}

protocol FileContentViewDelegate: NSObjectProtocol {
    /// 选中文件
    func fileView(fileView: FileContentViewProtocol, didSelectIndex index: Int)
}

//typealias XASQWWQ = <FileContentViewDataSource, FileContentViewDelegate>

protocol FileContentViewProtocol {
    
    init(fileDataSource: FileContentViewDataSource, fileDelegate: FileContentViewDelegate)
    
    func reload()
    
    func reloadItem(index: Int)
    
    func reloadItems(indexs: [Int])
    
    func deleteItems(indexs: [Int])
    
    func reloadAllItems()
    
    //    func setEditing(editing: Bool)
    
}

