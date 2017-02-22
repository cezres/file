//
//  FileModel.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation

protocol FileModelDelegate {
    func fileModel(model: FileModel)
}

class FileModel {
    
    let directoryPath: String
    
    var list = [File]()
    
    init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    func photos() -> [File] {
        return list.filter({ (file) -> Bool in
            return file.type == .Photo
        })
    }
    
    typealias FileFilter = (_ file: File) -> Bool
    
    var filters = [FileFilter]()
    
    /// 加载文件列表
    func loadFileList(completeBlock: @escaping () -> Void) {
        guard !Thread.isMainThread else {
            DispatchQueue.global().async {
                self.loadFileList(completeBlock: completeBlock)
            }
            return
        }
        
        var files = [File]()
        
        let filters = self.filters
        traverseDirectory(directoryPath: directoryPath) { (file) in
            guard filters.count > 0 else {
                files.append(file)
                return
            }
            for filter in filters {
                if !filter(file) {
                    return
                }
            }
            files.append(file)
        }
        files = files.sorted { (file1, file2) -> Bool in
            return file1.type < file2.type
        }
        
        OperationQueue.main.addOperation {
            self.list = files
            completeBlock()
        }
    }
    
    func createDir() {
        
    }
    
    /// 删除文件
    func deleteIndexs(idxs: [Int]) -> [Int] {
        guard idxs.count != 0 else {
            return []
        }
        /// 删除成功的文件
        var successIndexs = [Int]()
        var flag = 0
        for idx in idxs {
            do {
                let index = idx - flag
                try FileManager.default.removeItem(atPath: list[index].path)
                list.remove(at: index)
                flag += 1
                successIndexs.append(idx)
            }
            catch {
                
            }
        }
        return successIndexs
    }
    
}
