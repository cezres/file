//
//  FileListViewController.swift
//  file
//
//  Created by 翟泉 on 16/4/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
//import RxSwift

class FileListViewController: UIViewController {
    
    var viewModel: FileListViewModel! {
        didSet {
            viewModel.reloadSignal.subscribeNext { [unowned self](_) in
                self.tableView.reloadData()
            }
        }
    }
    
    /**
     初始化
     
     - parameter directoryPath: 相对于DocumentDirectory的目录路径
     
     */
    init(directoryPath: String = "") {
        super.init(nibName: nil, bundle: nil)
        if directoryPath == "" {
            title = "文件列表"
            viewModel = FileListViewModel(directoryPath: DocumentDirectory())
        }
        else {
            title = NSString(string: directoryPath).lastPathComponent
            viewModel = FileListViewModel(directoryPath: directoryPath)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        
        view.backgroundColor = UIColor.whiteColor()
        
        viewModel.loadFileList()
        
        setNormalNavigationItem()
    }
    
    func setNormalNavigationItem() {
        let editButtonItem = UIBarButtonItem(title: "选择", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListViewController.setEditNavigationItem))
        let newDirectoryButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(FileListViewController.newDirectory))
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = [editButtonItem, newDirectoryButtonItem]
        tabBarController?.tabBar.hidden = false
    }
    
    func setEditNavigationItem() {
        let normalButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListViewController.setNormalNavigationItem))
        let selectButtonItem = UIBarButtonItem(title: "全选", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListViewController.setNormalNavigationItem))
        navigationItem.leftBarButtonItems = [selectButtonItem]
        navigationItem.rightBarButtonItems = [normalButtonItem]
        tabBarController?.tabBar.hidden = true
    }
    
    func newDirectory() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height-64-49)
    }
    
    lazy var tableView: UITableView = {
        let lazy             = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        lazy.dataSource      = self
        lazy.delegate        = self
        lazy.backgroundColor = UIColor.whiteColor()
        lazy.separatorInset  = UIEdgeInsetsZero
        lazy.layoutMargins   = UIEdgeInsetsZero
        lazy.registerClass(FileListTableViewCell.classForCoder(), forCellReuseIdentifier: "File")
        self.view.addSubview(lazy)
        return lazy
    }()
    
}

extension FileListViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.files.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("File")!
    }
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let fileCell = cell as? FileListTableViewCell else {
            return
        }
        fileCell.layoutMargins = UIEdgeInsetsZero
        fileCell.setupData(viewModel.files[indexPath.row])
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        viewModel.didSelectFileAtIndex(indexPath.row, controller: self)
    }
}




