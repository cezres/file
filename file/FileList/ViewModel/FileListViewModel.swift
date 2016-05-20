//
//  FileListViewModel.swift
//  file
//
//  Created by 翟泉 on 16/4/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import ReactiveCocoa
import PhotoViewer

import VideoPlayer

protocol FileListViewModelDelegate: AnyObject {
    
    /**
     重新加载
     */
    func reloadAll()
    
    /**
     重新加载
     
     - parameter indexs: 索引
     */
    func reloadAtIndexs(indexs: [Int])
    
    /**
     从视图上添加文件
     
     - parameter indexs: 索引
     */
    func insertAtIndexs(indexs: [Int])
    
    /**
     从视图上移除文件
     
     - parameter indexs: 索引
     */
    func removeAtIndexs(indexs: [Int])
    
}

class FileListViewModel {
    
    // 文件列表
    var files = [File]()
    // 目录路径
    private let directoryPath: String

    weak var delegate: FileListViewModelDelegate?
    
    weak var viewController: UIViewController?
    
    let selectState = RACSubject()
    
    
    
    
    /**
     初始化
     
     - parameter directoryPath: 目录路径
     
     */
    init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    deinit {
        print(self)
    }
    
    /**
     加载文件列表
     */
    func loadFileList() {
        let start = CACurrentMediaTime()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var files = [File]()
            FileServices.traverseDirectory(self.directoryPath) { /*[unowned self]*/(file) in
                files.append(file)
            }
            
            files.sortInPlace { (f1, f2) -> Bool in
                return f1.type < f2.type
            }
            dispatch_sync(dispatch_get_main_queue(), {
                self.files = files
                let end = CACurrentMediaTime()
                print("测量时间：\(Float(end - start))")
                self.delegate?.reloadAll()
            })
        }
    }
    
    /**
     新建文件夹
     
     - parameter directoryName: 文件夹名称
     */
    func newDirectory(directoryName: NSString)
    {
        guard directoryName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 else {
            return
        }
        guard directoryName.rangeOfString("/").length <= 0 else {
            return
        }
        
        let directoryPath = self.directoryPath + "/" + (directoryName as String)
        
        guard FileServices.createDirectory(directoryPath) else {
            return
        }
        
        files.insert(File(path: directoryPath), atIndex: 0)
        delegate?.insertAtIndexs([0])
    }
    
    
    // MARK: - 编辑
    
    var selected = [Bool]()
    
    var editing: Bool = false {
        didSet {
            guard oldValue != editing else {
                return
            }
            
            if editing {
                for _ in 0 ..< files.count {
                    selected.append(false)
                }
            }
            else {
                selected.removeAll()
            }
            delegate?.reloadAll()
        }
    }
    
    
    // MARK: - SelectAll
    func selectAll() {
        let array = selected.filter { (bl) -> Bool in
            return !bl
        }
        
        selected.removeAll()
        if array.count == 0 {
            for _ in 0 ..< files.count {
                selected.append(false)
            }
        }
        else {
            for _ in 0 ..< files.count {
                selected.append(true)
            }
        }
        delegate?.reloadAll()
        
        checkSelectState()
    }
    
    func checkSelectState() {
        let array = selected.filter { (bl) -> Bool in
            return !bl
        }
        if array.count == 0 {
            // 取消全选
            selectState.sendNext("取消全选")
        }
        else {
            // 全选
            selectState.sendNext("全选")
//            NSNotificationCenter.defaultCenter().postNotificationName("FileListSelectState", object: nil, userInfo: ["title": "全选"])
        }
    }
    
}

extension FileListViewModel: FileListViewDataSource {
    
    func fileCount() -> Int {
        return files.count
    }
    
    func fileForIndex(index: Int) -> File {
        return files[index]
    }
    
    func isSelectedForIndex(index: Int) -> Bool {
        return selected[index]
    }
    
    func selectFileAtIndex(index: Int) {
        if editing {
            selected[index] = !selected[index]
            delegate?.reloadAll()
            
            checkSelectState()
        }
        else {
            openFile(files[index])
        }
    }
    
    func openFile(file: File) {
        switch file.type {
        case .Directory:
            viewController?.navigationController?.pushViewController(FileListViewController(directoryPath: file.path), animated: true)
        case .Video:
            var dict = [NSObject : AnyObject]()
            if file.pathExtension == "wmv" {
                dict[KxMovieParameterMinBufferedDuration] = NSNumber(float: 5.0)
            }
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
                dict[KxMovieParameterDisableDeinterlacing] = NSNumber(bool: true)
            }
            let KxMovie = KxMovieViewController.movieViewControllerWithContentPath(file.path, parameters: dict as [NSObject : AnyObject]) as! UIViewController
            viewController?.presentViewController(KxMovie, animated: true, completion: nil)
        case .Photo:
            var filePaths = [String]()
            var index = -1
            for _file in files {
                if _file.type == .Photo {
                    filePaths.append(_file.path)
                    if index == -1 && _file == file {
                        index = filePaths.count - 1
                    }
                }
                
            }
            let photoViewer = PhotoViewer(filePaths: filePaths, index: index)
            viewController?.navigationController?.pushViewController(photoViewer, animated: false)
            break
        default:
            break
        }
    }
    
}

// MARK: - 工具栏
extension FileListViewModel: FileListToolBarDelegate {
    
    @objc func move() {
        let selectDirectory = SelectDirectoryViewController()
        selectDirectory.selecteDirectoryCallback = { (path: String) in
            
            guard let controller = self.viewController as? FileListViewController else {
                return
            }
            print(controller.viewModel.directoryPath)
            print(path)
            
            
            
            guard self.directoryPath != path else {
                controller.setNormalNavigationItem()
                controller.navigationController?.popToViewController(controller, animated: true)
                return
            }
            
            var rmIndexs = [Int]()
            for i in 0 ..< self.selected.count {
                if self.selected[i] {
                    let index = i - rmIndexs.count
                    
                    if FileServices.moveFile(self.files[index].path, toPath: path+"/"+self.files[index].lastPathComponent) {
                        rmIndexs.append(i)
                        self.files.removeAtIndex(index)
                    }
                }
            }
            self.delegate?.removeAtIndexs(rmIndexs)
            
            if path.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < self.directoryPath.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
                // 如果移动的目标目录是当前目录的上级目录  需要更新目标目录界面
                for vc in controller.navigationController!.viewControllers {
                    if let fileList = vc as? FileListViewController {
                        if fileList.viewModel.directoryPath == path {
                            fileList.viewModel.loadFileList()
                            break
                        }
                    }
                }
            }
            
//            controller.setNormalNavigationItem()
            controller.navigationController?.popToViewController(controller, animated: true)
            
        }
        
        viewController?.navigationController?.pushViewController(selectDirectory, animated: true)
    }
    
    @objc func delete() {
//        guard let controller = self.viewController as? FileListViewController else {
//            return
//        }
        var rmIndexs = [Int]()
        for i in 0 ..< selected.count {
            if selected[i] {
                let index = i - rmIndexs.count
                if FileServices.removeFile(files[index].path) {
                    rmIndexs.append(i)
                    files.removeAtIndex(index)
                }
            }
        }
        delegate?.removeAtIndexs(rmIndexs)
//        controller.setNormalNavigationItem()
    }
    
    @objc func copy() {
        let selectDirectory = SelectDirectoryViewController()
        selectDirectory.selecteDirectoryCallback = { (path: String) in
            
            guard let controller = self.viewController as? FileListViewController else {
                return
            }
            print(controller.viewModel.directoryPath)
            print(path)
            
            
            
            guard self.directoryPath != path else {
                controller.setNormalNavigationItem()
                controller.navigationController?.popToViewController(controller, animated: true)
                return
            }
            
            for i in 0 ..< self.selected.count {
                if self.selected[i] {
                    FileServices.copyFile(self.files[i].path, toPath: path+"/"+self.files[i].lastPathComponent)
                }
            }
//            self.delegate?.removeAtIndexs(rmIndexs)
            
            if path.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < self.directoryPath.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
                // 如果移动的目标目录是当前目录的上级目录  需要更新目标目录界面
                for vc in controller.navigationController!.viewControllers {
                    if let fileList = vc as? FileListViewController {
                        if fileList.viewModel.directoryPath == path {
                            fileList.viewModel.loadFileList()
                            break
                        }
                    }
                }
            }
            
            controller.setNormalNavigationItem()
            controller.navigationController?.popToViewController(controller, animated: true)
            
        }
        
        viewController?.navigationController?.pushViewController(selectDirectory, animated: true)
    }
}

