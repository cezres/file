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
    
    init(directoryPath: String = "") {
        super.init(nibName: nil, bundle: nil)
        if directoryPath == "" {
            model = FileListModel(directoryPath: DocumentDirectory())
            let meunButtonItem = UIBarButtonItem(title: "菜单", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
            navigationItem.leftBarButtonItems = [meunButtonItem]
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
                self.view.addSubview(self.fileListView)
                self.fileListView.snp_makeConstraints { (make) in
                    make.top.equalTo(64)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
                }
            })
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
            navigationController?.pushViewController(PhotoViewer(imagePaths: filePaths, index: index), animated: true)
        }
        else if fileEntity.type == FileType.Audio {
            MusicPlayManager.default.play(path: fileEntity.absPath)
//            print(MusicEntity(path: fileEntity.absPath))
        }
    }

}
