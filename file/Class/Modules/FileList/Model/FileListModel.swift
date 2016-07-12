//
//  FileListModel.swift
//  file
//
//  Created by 翟泉 on 2016/6/28.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileListModel {
    
    
    private let directoryPath: String
    
    var files = [FileEntity]()
    
    
    var fileFilter: ((file: FileEntity) -> Bool)?
    
    
    init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    func directoryName() -> String {
        guard directoryPath != DocumentDirectory() else {
            return "Root Directory"
        }
        return NSString(string: directoryPath).lastPathComponent
    }
    
    func loadFiles() {
        files.removeAll()
        traverseDirectory(directoryPath: directoryPath) { (file) in
            print(file.name)
            self.files.append(file)
        }
        
        
        if let filter = fileFilter {
            files = files.filter { (file) -> Bool in
                return filter(file: file)
            }
        }
        
        
        files.sort { (file1, file2) -> Bool in
            return file1.type < file2.type
        }
        
        
        
    }
    
    func newDirectory(name: String) -> Bool {
        let path = directoryPath + "/" + name
        do {
            try FileManager.default().createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            let file = FileEntity(path: path)
            files.insert(file, at: 0)
            return true
        }
        catch {
            return false
        }
    }
    
    func deleteFiles(idxs: [Int]) -> Bool {
        guard idxs.count != 0 else {
            return false
        }
        var flag = 0
        for idx in idxs {
            do {
                let index = idx - flag
                try FileManager.default().removeItem(atPath: files[index].absPath)
                files.remove(at: index)
                flag += 1
            }
            catch {
                
            }
        }
        return flag > 0
    }
    
    func moveFiles(idxs: [Int], to directoryPath: String) -> Bool {
        guard idxs.count != 0 else {
            return false
        }
        
        return true
    }
    
    
    
    private typealias Callback = (file: FileEntity)->Void
    
    private func traverseDirectory(directoryPath: String, subDirectory: Bool = false, callback: Callback) {
        do {
            let contents = try FileManager.default().contentsOfDirectory(atPath: directoryPath)
            for content in contents {
                let filePath = directoryPath + "/" + content
                let file = FileEntity(path: filePath)
                callback(file: file)
                if subDirectory && file.type == FileType.Directory {
                    traverseDirectory(directoryPath: filePath, subDirectory: true, callback: callback)
                }
            }
        }
        catch {
            
        }
    }
    
}
