//
//  FileTableView.swift
//  file
//
//  Created by 翟泉 on 2016/9/24.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileTableView: UITableView {
    
    weak var fileDataSource: FileContentViewDataSource!
    weak var fileDelegate: FileContentViewDelegate!

    init(fileDataSource: FileContentViewDataSource, fileDelegate: FileContentViewDelegate) {
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
    
}
