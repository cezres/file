//
//  FileTableView.swift
//  file
//
//  Created by 翟泉 on 2017/2/22.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit

class FileTableView: UITableView, FileContentViewProtocol {
    
    weak var fileDataSource: FileContentViewDataSource!
    weak var fileDelegate: FileContentViewDelegate!
    
    required init(fileDataSource: FileContentViewDataSource, fileDelegate: FileContentViewDelegate) {
        super.init(frame: CGRect(), style: UITableViewStyle.plain)
        self.fileDataSource = fileDataSource
        self.fileDelegate = fileDelegate
        
        delegate = self
        dataSource = self
        
        backgroundColor = UIColor.white
        rowHeight = 60
        
        register(FileTableViewCell.classForCoder(), forCellReuseIdentifier: "File")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func change(for change: ListChange) {
        switch change.type {
        case .reloadAll:
            reloadData()
        case .insert:
            insertRows(at: IndexPath.indexs(for: change.indexs), with: .left)
        case .delete:
            deleteRows(at: IndexPath.indexs(for: change.indexs), with: .right)
        case .reload:
            reloadRows(at: IndexPath.indexs(for: change.indexs), with: .automatic)
        case .move:
            beginUpdates()
            for moveIndex in change.moveIndexs {
                let indexPath = IndexPath(row: moveIndex.index, section: 0)
                let newIndexPath = IndexPath(row: moveIndex.newIndex, section: 0)
                moveRow(at: indexPath, to: newIndexPath)
            }
            endUpdates()
        case .reloadVisible:
            for cell in visibleCells {
                if let indexPath = indexPath(for: cell) {
                    tableView(self, willDisplay: cell, forRowAt: indexPath)
                }
            }
        }
    }
    
    
    func reload() {
        reloadData()
    }
    
    func reloadItem(index: Int) {
        
    }
    
    func reloadItems(indexs: [Int]) {
        
    }
    
    func deleteItems(indexs: [Int]) {
        
    }
    
    func reloadAllItems() {
        
    }
    
}


extension FileTableView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileDataSource.list().count
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fileCell = tableView.dequeueReusableCell(withIdentifier: "File")!
        return fileCell
    }
    
    // MARK: - Data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let fileCell = cell as? FileTableViewCell else {
            return
        }
        fileCell.file = fileDataSource.list()[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        fileDelegate.fileView(fileView: self, didSelectIndex: indexPath.row)
    }
    
}
