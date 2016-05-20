//
//  FileListViewController.swift
//  file
//
//  Created by 翟泉 on 16/4/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
//import RxSwift
import RESideMenu

class FileListViewController: UIViewController {
    
    var viewModel: FileListViewModel!
    
    let listView = FileListView()
    
    // 选中
    var selected = [Bool]()
    
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
    
    deinit {
        print(NSStringFromClass(classForCoder))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        view.backgroundColor = UIColor.whiteColor()
        
        if SettingServices.sharedInstance.filelistDisplayMode == .CollectionView {
            listView.initWithCollectionView()
        }
        else {
            listView.initWithTableView()
        }
        
        view.addSubview(listView)
        listView.dataSource = viewModel
        
        viewModel.delegate = listView
        viewModel.viewController = self
        viewModel.loadFileList()
        
        setNormalNavigationItem()
        
        
        viewModel.selectState.subscribeNext { [weak self](object) in
            guard let title = object as? String else {
                return
            }
            guard self != nil else {
                return
            }
            guard self!.navigationItem.leftBarButtonItem?.title != title else {
                return
            }
            self!.navigationItem.leftBarButtonItem?.title = title
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillLayoutSubviews() {
        
        
//        if view.bounds.width == listView.frame.width {
//            return
//        }
        
        if view.bounds.width > view.bounds.height {
            listView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height-44)
        }
        else {
            listView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height-64)
        }
//        if toolBar.show {
//            listView.frame = CGRectMake(0, listView.y, listView.frame.width, listView.frame.height-toolBar.frame.height)
//            toolBar.frame = CGRectMake(0, view.frame.height-49, view.frame.width, 49)
//        }
//        else {
//            toolBar.frame = CGRectMake(0, view.frame.height, view.frame.width, 49)
//        }
        
        super.viewWillLayoutSubviews()
    }
    
    
    func setNormalNavigationItem() {
        if self.navigationController?.viewControllers.count == 1 {
            let meunButtonItem = UIBarButtonItem(title: "菜单", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
            navigationItem.leftBarButtonItems = [meunButtonItem]
        }
        else {
            navigationItem.leftBarButtonItems = []
        }
        
        let editButtonItem = UIBarButtonItem(title: "选择", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListViewController.setEditNavigationItem))
        let newDirectoryButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(FileListViewController.newDirectory))
        
        navigationItem.rightBarButtonItems = [editButtonItem, newDirectoryButtonItem]
        tabBarController?.tabBar.hidden = false
        
        viewModel.editing = false
        toolBar.show = false
        
        sideMenuViewController.panGestureEnabled = true
        
        if toolBar.show {
            listView.frame = CGRectMake(0, listView.y, listView.frame.width, listView.frame.height-toolBar.frame.height)
            toolBar.frame = CGRectMake(0, view.frame.height-49, view.frame.width, 49)
        }
        else {
            listView.frame = CGRectMake(0, listView.y, listView.frame.width, listView.frame.height)
            toolBar.frame = CGRectMake(0, view.frame.height, view.frame.width, 49)
        }
    }
    
    func setEditNavigationItem() {
        let normalButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListViewController.setNormalNavigationItem))
        let selectButtonItem = UIBarButtonItem(title: "全选", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListViewController.selectAllFile))
        navigationItem.leftBarButtonItems = [selectButtonItem]
        navigationItem.rightBarButtonItems = [normalButtonItem]
        tabBarController?.tabBar.hidden = true
        
        viewModel.editing = true
        toolBar.show = true
        
        sideMenuViewController.panGestureEnabled = false
        
        if toolBar.show {
            listView.frame = CGRectMake(0, listView.y, listView.frame.width, listView.frame.height-toolBar.frame.height)
            toolBar.frame = CGRectMake(0, view.frame.height-49, view.frame.width, 49)
        }
        else {
            listView.frame = CGRectMake(0, listView.y, listView.frame.width, listView.frame.height)
            toolBar.frame = CGRectMake(0, view.frame.height, view.frame.width, 49)
        }
        
        
        
    }
    
    func newDirectory() {
        TextFieldAlertView.show("新建文件夹") { (text) in
            self.viewModel.newDirectory(text)
        }
//        sideMenuViewController.presentRightMenuViewController()
    }
    
    func selectAllFile() {
        viewModel.selectAll()
    }
    
    // MARK: - InitSubviews
    lazy var toolBar: FileListToolBar = {
        let lazy = FileListToolBar()
        lazy.toolDelegate = self.viewModel
        self.view.addSubview(lazy)
        return lazy
    }()
}





