//
//  FileListViewController.swift
//  file
//
//  Created by cezr on 16/6/23.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit



class FileListViewController/*<FileListView: UIView where FileListView: FileListViewProtocol>*/: UIViewController, FileListViewDelegate {
    
    var model: FileListModel!
    
    var fileListView: FileListView!
    
    lazy var toolView = FileListToolView()
    
    init(directoryPath: String = "") {
        super.init(nibName: nil, bundle: nil)
        if directoryPath == "" {
            model = FileListModel(directoryPath: DocumentDirectory())
        }
        else {
            model = FileListModel(directoryPath: directoryPath)
        }
        title = model.directoryName()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(classForCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        view.backgroundColor = UIColor.white()
        
        OperationQueue().addOperation { 
            self.model.loadFiles()
            OperationQueue.main().addOperation({
                self.fileListView = FileListCollectionView(delegate: self)
                self.toolView.delegate = self
                self.view.addSubview(self.fileListView)
                self.view.addSubview(self.toolView)
                
                self.fileListView.snp_makeConstraints { (make) in
                    make.top.equalTo(64)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(self.toolView.snp_top)
                }
                
                self.toolView.snp_makeConstraints { (make) in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
                }
                
                self.setNormalNavigationItem()
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if navigationController?.viewControllers.count == 1 {
            sideMenuViewController.panGestureEnabled = true
        }
        else {
            sideMenuViewController.panGestureEnabled = false
        }
        super.viewWillAppear(animated)
    }
    
    
    func setNormalNavigationItem() {
        if navigationController?.viewControllers.count == 1 {
            let meunButtonItem = UIBarButtonItem(title: "菜单", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
            navigationItem.leftBarButtonItems = [meunButtonItem]
        }
        else {
            navigationItem.leftBarButtonItems = []
        }
        
        let editButtonItem = UIBarButtonItem(title: "选择", style: UIBarButtonItemStyle.done, target: self, action: #selector(FileListViewController.setEditNavigationItem))
        let newDirectoryButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(FileListViewController.newDirectory))
        navigationItem.rightBarButtonItems = [editButtonItem, newDirectoryButtonItem]
        
        fileListView.setEditing(editing: false)
        
        toolView.snp_updateConstraints { (make) in
            make.height.equalTo(0)
        }
        toolView.isHidden = true
    }
    
    func setEditNavigationItem() {
        let normalButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.done, target: self, action: #selector(FileListViewController.setNormalNavigationItem))
        let selectButtonItem = UIBarButtonItem(title: "全选", style: UIBarButtonItemStyle.done, target: self, action: #selector(FileListViewController.selectedAll))
        navigationItem.leftBarButtonItems = [selectButtonItem]
        navigationItem.rightBarButtonItems = [normalButtonItem]
        
        fileListView.setEditing(editing: true)
        
        toolView.snp_updateConstraints { (make) in
            make.height.equalTo(49)
        }
        toolView.isHidden = false
    }
    
    func newDirectory() {
        let alert = UIAlertController(title: "新建文件夹", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (text) in
            text.placeholder = "输入文件夹名称"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            UIApplication.shared().keyWindow?.endEditing(true)
        }
        let confimAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (_) in
            UIApplication.shared().keyWindow?.endEditing(true)
            guard let textField = alert.textFields?[0] else {
                return
            }
            if self.model.newDirectory(name: textField.text!) {
                self.fileListView.reload()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confimAction)
        
        present(alert, animated: true)
    }
    
    func selectedAll() {
        fileListView.selectAll()
    }
    
    
    // MARK: - FileListViewDelegate
    func count() -> Int {
        return model.files.count
    }
    
    func fileEntity(index: Int) -> FileEntity {
        return model.files[index]
    }
    
    func selectedFile(index: Int) {
        print(model.files[index].name)
        
        let fileEntity = model.files[index]
        if fileEntity.type == FileType.Directory {
            navigationController?.pushViewController(FileListViewController(directoryPath: fileEntity.absPath), animated: true)
        }
        else if fileEntity.type == FileType.Photo {
            var filePaths = [String]()
            var index = 0
            for file in model.files {
                if file.type == FileType.Photo {
                    filePaths.append(file.absPath)
                    if file.path == fileEntity.path {
                        index = filePaths.count - 1
                    }
                }
            }
            sideMenuViewController.panGestureEnabled = false
            navigationController?.pushViewController(PhotoViewer(imagePaths: filePaths, index: index), animated: true)
        }
        else if fileEntity.type == FileType.Audio {
            MusicPlayManager.default.play(path: fileEntity.absPath)
        }
        
    }

}


extension FileListViewController: FileListToolViewDelegate {
    
    func copyFile() {
        
    }
    
    func moveFile() {
        sideMenuViewController.panGestureEnabled = false
        unowned let weakself = self
        let selectDirectory = SelectDirectoryViewController { (directoryPath) in
            weakself.model.moveFiles(idxs: weakself.fileListView.selectedItems(), to: directoryPath)
        }
        navigationController?.pushViewController(selectDirectory, animated: true)
    }
    
    func deleteFile() {
        let alert = UIAlertController(title: "删除文件", message: "确认删除文件?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
        }
        let confimAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (_) in
            guard self.model.deleteFiles(idxs: self.fileListView.selectedItems()) else {
                return
            }
            self.setNormalNavigationItem()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confimAction)
        
        present(alert, animated: true)
    }
    
    func compressFile() {
        
    }
    
}
