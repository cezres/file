//
//  SelectDirectoryViewModel.swift
//  file
//
//  Created by 翟泉 on 16/5/19.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation

class SelectDirectoryViewModel {
    
    // 文件列表
    var files = [File]()
    // 目录路径
    private let directoryPath: String
    
    weak var delegate: FileListViewModelDelegate?
    
    weak var viewController: SelectDirectoryViewController?
    
    init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    func loadFileList() {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var files = [File]()
            FileServices.traverseDirectory(self.directoryPath) { (file) in
                guard file.type == .Directory else {
                    return
                }
                files.append(file)
            }
            dispatch_sync(dispatch_get_main_queue(), {
                self.files = files
                self.delegate?.reloadAll()
            })
        }
    }
    
}


extension SelectDirectoryViewModel: FileListViewDataSource {
    
    func fileCount() -> Int {
        return files.count
    }
    
    func fileForIndex(index: Int) -> File {
        return files[index]
    }
    
    func isSelectedForIndex(index: Int) -> Bool {
        return false
    }
    
    func selectFileAtIndex(index: Int) {
        let selectDirectory = SelectDirectoryViewController(directoryPath: files[index].path)
        selectDirectory.selecteDirectoryCallback = viewController?.selecteDirectoryCallback
        viewController?.navigationController?.pushViewController(selectDirectory, animated: true)
    }
    
}



