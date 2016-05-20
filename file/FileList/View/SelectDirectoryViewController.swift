//
//  SelectDirectoryViewController.swift
//  file
//
//  Created by 翟泉 on 16/5/19.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

//protocol SelectDirectoryViewControllerDelegate: AnyObject {
//    func selectedDirectory(path: String)
//}

class SelectDirectoryViewController: UIViewController {

    let viewModel: SelectDirectoryViewModel
    
    let listView = FileListView()
    
//    weak var delegate: SelectDirectoryViewControllerDelegate?
    
    let confirmButton = UIButton(type: UIButtonType.System)
    
    var selecteDirectoryCallback: ((path: String)->Void)?
    
    let directoryPath: String
    
    init(directoryPath: String = "") {
        if directoryPath == "" {
            viewModel = SelectDirectoryViewModel(directoryPath: DocumentDirectory())
            self.directoryPath = DocumentDirectory()
        }
        else {
            viewModel = SelectDirectoryViewModel(directoryPath: directoryPath)
            self.directoryPath = directoryPath
        }
        
        super.init(nibName: nil, bundle: nil)
        if directoryPath == "" {
            title = "文件列表"
        }
        else {
            title = NSString(string: directoryPath).lastPathComponent
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "选择文件夹"
        
        view.addSubview(UIView())
        view.backgroundColor = UIColor.whiteColor()
        
        
        listView.initWithTableView()
        view.addSubview(listView)
        listView.dataSource = viewModel
        
        viewModel.delegate = listView
        viewModel.viewController = self
        viewModel.loadFileList()
        
        confirmButton.setTitle("确定", forState: UIControlState.Normal)
        view.addSubview(confirmButton)
        confirmButton.addTarget(self, action: #selector(SelectDirectoryViewController.confirm), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func confirm() {
        selecteDirectoryCallback?(path: directoryPath)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if view.bounds.width > view.bounds.height {
            listView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height-44-49)
            confirmButton.frame = CGRectMake(0, view.frame.height-49, view.frame.width, 49)
        }
        else {
            listView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height-64-49)
            confirmButton.frame = CGRectMake(0, view.frame.height-49, view.frame.width, 49)
        }
    }

}
