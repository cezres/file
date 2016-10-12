//
//  FileModel.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


//protocol FileModelDelegate: NSObjectProtocol {
//    
//    func fileLoadingComplete(files: [File])
//    
//}


class FileModel {
    
    let directoryPath: String
    
//    weak var delegate: FileModelDelegate?
    
    var list = [File]()
    
    init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    /// 加载文件列表
    func loadFileList(completeBlock: @escaping () -> Void) {
        guard !Thread.isMainThread else {
            OperationQueue().addOperation({
                self.loadFileList(completeBlock: completeBlock)
            })
            return
        }
        var files = [File]()
        traverseDirectory(directoryPath: directoryPath) { (file) in
            files.append(file)
        }
        
        list = files.sorted { (file1, file2) -> Bool in
            return file1.type < file2.type
        }
//        list = files
        OperationQueue.main.addOperation {
            completeBlock()
        }
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
