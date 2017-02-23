//
//  FileView.swift
//  file
//
//  Created by 翟泉 on 2016/9/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


protocol FileViewDelegate: NSObjectProtocol {
    /// 选中文件
    func fileView(fileView: FileView, didSelectedFile file: File)
    
    /// 文件列表
    func list() -> [File]
    
}


class FileView: UIView, FileContentViewDataSource, FileContentViewDelegate {
    
    private var contentView: FileContentViewProtocol!
    
    weak var delegate: FileViewDelegate!
    
    
    
    /// 设置编辑状态
    func setEditing(editing: Bool) {
        _isEditing = editing
        if _isEditing {
            isSelecteds = Array<Bool>(repeating: false, count: delegate.list().count)
        }
        else {
            isSelecteds = []
        }
        contentView.change(for: ListChange.reloadVisible)
    }
    
    func deleteItems(idxs: [Int]) {
        contentView.change(for: ListChange.delete(indexs: idxs))
    }
    
    var isSelecteds = [Bool]()
    
    func selectedIndexs() -> [Int] {
        var indexs = [Int]()
        for (idx, bool) in isSelecteds.enumerated() {
            if bool {
                indexs.append(idx)
            }
        }
        return indexs
    }
    
    
    
    // MARK: - FileViewDataSource
    func list() -> [File] {
        return delegate.list()
    }
    
    func isSelected(index: Int) -> Bool {
        return isSelecteds[index]
    }
    
    var isEditing: Bool {
        get {
            return _isEditing
        }
    }
    
    // MARK: - FileViewDelegate
    func fileView(fileView: FileContentViewProtocol, didSelectIndex index: Int) {
        if isEditing {
            isSelecteds[index] = !isSelecteds[index]
            contentView.change(for: ListChange.reload(indexs: [index]))
        }
        else {
            delegate?.fileView(fileView: self, didSelectedFile: delegate.list()[index])
        }
    }
    
    private var _isEditing = false
    
    init() {
        super.init(frame: CGRect())
        backgroundColor = UIColor.white
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        contentView.change(for: ListChange.reloadAll)
    }
    
    func change(for change: ListChange) {
        contentView.change(for: change)
    }
    
    func initSubviews() {
        let collectionView = FileCollectionView(fileDataSource: self, fileDelegate: self)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        collectionView.selectFile = { [weak self](file) in
            self?.delegate?.fileView(fileView: self!, didSelectedFile: file)
        }
        contentView = collectionView
    }
    
}
