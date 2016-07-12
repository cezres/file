//
//  SelectDirectoryViewController.swift
//  file
//
//  Created by 翟泉 on 2016/7/12.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class SelectDirectoryViewController: UIViewController, FileListViewDelegate {
    
    var model: FileListModel!
    
    var fileListView: FileListView!
    
    var confimButton: UIButton!
    var cancelButton: UIButton!
    
    var handler: ((directoryPath: String) -> Void)?
    
    init(directoryPath: String = "", handler: ((directoryPath: String) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        if directoryPath == "" {
            model = FileListModel(directoryPath: DocumentDirectory())
            navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)]
            title = "选择文件夹"
        }
        else {
            model = FileListModel(directoryPath: directoryPath)
            title = model.directoryName()
        }
        self.handler = handler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        view.backgroundColor = UIColor.white()
        
        model.fileFilter = { (file: FileEntity) -> Bool in
            return file.type == FileType.Directory
        }
        
        
        OperationQueue().addOperation { 
            self.model.loadFiles()
            OperationQueue.main().addOperation({ 
                self.initSubviews()
            })
        }
        
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
//        let dele = navigationController?.interactivePopGestureRecognizer?.delegate
//        print(dele)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if title == "选择文件夹" {
            navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = false
        }
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = true
        super.viewDidDisappear(animated)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func confim() {
        
    }
    
    func initSubviews() {
        fileListView = FIleListTableView(delegate: self)
        view.addSubview(fileListView)
        confimButton = UIButton(type: UIButtonType.system)
        confimButton.setTitle("确定", for: UIControlState(rawValue: 0))
        confimButton.backgroundColor = UIColor(white: 0.8, alpha: 1)
        confimButton.addTarget(self, action: #selector(SelectDirectoryViewController.confim), for: UIControlEvents.touchUpInside)
        view.addSubview(confimButton)
        cancelButton = UIButton(type: UIButtonType.system)
        cancelButton.setTitle("取消", for: UIControlState(rawValue: 0))
        cancelButton.backgroundColor = UIColor(white: 0.8, alpha: 1)
        cancelButton.addTarget(self, action: #selector(SelectDirectoryViewController.cancel), for: UIControlEvents.touchUpInside)
        view.addSubview(cancelButton)
        
        
        
        fileListView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(64)
            make.bottom.equalTo(confimButton.snp_top)
        }
        confimButton.snp_makeConstraints { (make) in
            make.left.equalTo(view.snp_centerX)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(49)
        }
        cancelButton.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(view.snp_centerX)
            make.bottom.equalTo(0)
            make.height.equalTo(49)
        }
        
    }
    
    

    // MARK: - FileListViewDelegate
    func count() -> Int {
        return model.files.count
    }
    
    func fileEntity(index: Int) -> FileEntity {
        return model.files[index]
    }
    
    func selectedFile(index: Int) {
        let path = fileEntity(index: index).absPath
        navigationController?.pushViewController(SelectDirectoryViewController(directoryPath: path, handler: handler), animated: true)
    }
    
    
    

}
