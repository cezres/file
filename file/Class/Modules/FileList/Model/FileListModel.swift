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
        files.sort { (file1, file2) -> Bool in
            return file1.type < file2.type
        }
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
