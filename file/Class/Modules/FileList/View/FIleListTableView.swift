//
//  FIleListTableView.swift
//  file
//
//  Created by 翟泉 on 2016/7/12.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FIleListTableView: FileListView, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!

    required init(delegate: FileListViewDelegate) {
        super.init(delegate: delegate)
        
        tableView = UITableView(frame: CGRect(), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white()
        tableView.register(FileTableViewCell.classForCoder(), forCellReuseIdentifier: "File")
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - FileListViewProtocol
    
    override func reload() {
        tableView.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "File")!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FileTableViewCell else {
            return
        }
        cell.setFileEntity(file: delegate.fileEntity(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.selectedFile(index: indexPath.row)
    }
    
}
