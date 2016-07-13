//
//  FileListModel.swift
//  file
//
//  Created by 翟泉 on 2016/6/28.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import Zip

class FileListModel {
    
    
    
    let directoryPath: String
    
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
            self.files.append(file)
        }
        
        
        if let filter = fileFilter {
            files = files.filter { (file) -> Bool in
                return filter(file: file)
            }
        }
        
        sort()
        
    }
    
    func sort() {
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
    
    @discardableResult
    func moveFiles(idxs: [Int], toDirectoryPath: String) -> [FileEntity] {
        guard idxs.count != 0 else {
            return []
        }
        var items = [FileEntity]()
        for idx in idxs {
            do {
                let index = idx - items.count
                let file = files[index]
                
                let toPath = newFilePath(path: toDirectoryPath + "/" + file.name)
                
                try FileManager.default().moveItem(atPath: file.absPath, toPath: toPath)
                files.remove(at: index)
                items.append(FileEntity(path: toPath))
            }
            catch {
                
            }
        }
        return items
    }
    
    
    func copyFiles(idxs: [Int], toDirectoryPath: String) -> [FileEntity] {
        guard idxs.count != 0 else {
            return []
        }
        var items = [FileEntity]()
        for idx in idxs {
            do {
                let file = files[idx]
                
                let toPath = newFilePath(path: toDirectoryPath + "/" + file.name)
                
                try FileManager.default().copyItem(atPath: file.absPath, toPath: toPath)
                items.append(FileEntity(path: toPath))
            }
            catch {
                
            }
        }
        return items
    }
    
    
    func zipFiles(idxs: [Int]) -> Bool {
        guard idxs.count != 0 else {
            return false
        }
        
        var urls = [NSURL]()
        
        for idx in idxs {
            let url = NSURL(fileURLWithPath: files[idx].absPath)
            urls.append(url)
        }
        
        do {
            var zipPath: String
            if idxs.count == 1 {
                zipPath = (files[idxs[0]].name as NSString).deletingPathExtension
            }
            else {
                zipPath = "归档"
            }
            zipPath = directoryPath + "/\(zipPath).zip"
            zipPath = newFilePath(path: zipPath)
            
            try Zip.zipFiles(paths: urls, zipFilePath: NSURL(fileURLWithPath: zipPath), password: nil, progress: { (progress) in
                print(progress)
            })
            
            let file = FileEntity(path: zipPath)
            files.append(file)
            
            return true
        }
        catch {
            print(error)
            return false
        }
        
    }
    
    
    func unzipFile(idx: Int) -> Bool {
        
        do {
            var unZipPath = (directoryPath as NSString).appendingPathComponent((files[idx].name as NSString).deletingPathExtension)
            unZipPath = newFilePath(path: unZipPath)
            try FileManager.default().createDirectory(atPath: unZipPath, withIntermediateDirectories: true, attributes: nil)
            try Zip.unzipFile(zipFilePath: NSURL(fileURLWithPath: files[idx].absPath), destination: NSURL(fileURLWithPath: unZipPath), overwrite: true, password: nil, progress: { (progress) in
                print(progress)
            })
            
            let file = FileEntity(path: unZipPath)
            files.append(file)
            return true
        }
        catch {
            return false
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
    
    
    
    func newFilePath(path: String) -> String {
        
        let nsPath = NSString(string: path)
        
        let name = (nsPath.lastPathComponent as NSString).deletingPathExtension
        let directory = nsPath.deletingLastPathComponent
        let pathExtension = nsPath.pathExtension
        
        var flag = 1
        var newPath = path
        while FileManager.default().fileExists(atPath: newPath) {
            if pathExtension == "" {
                newPath = directory + "/" + name + "(\(flag))"
            }
            else {
                newPath = directory + "/" + name + "(\(flag))." + pathExtension
            }
            
            flag += 1
        }
        
        return newPath
    }
    
}
