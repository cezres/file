//
//  FileModel.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import ReactiveSwift


private let FileModelQueue = DispatchQueue(label: "FileModel")

class FileModel {
    
    // 目录路径
    let directoryPath: String
    // 文件列表
    var list: [File] {
        return _list
    }
    
    // 文件列表变更信号
    let changeSignal: Signal<ListChange, NSError>
    
    private var _list = [File]()
    private let changeObserver: Observer<ListChange, NSError>
    
    // 过滤
    typealias FileFilter = (_ file: File) -> Bool
    var filters = [FileFilter]()
    // 排序
    var sort: ((File, File) -> Bool)?
    
    
    /// 初始化
    ///
    /// - Parameter directoryPath: 目录路径
    init(directoryPath: String) {
        self.directoryPath = directoryPath
        (changeSignal, changeObserver) = Signal<ListChange, NSError>.pipe()
        sort = { (file1, file2) -> Bool in
            return file1.type < file2.type
        }
    }
    
    
    // MARK: ---
    
    
    /// 加载文件列表
    func loadFileList() {
        guard !Thread.isMainThread else {
            FileModelQueue.async { [weak self] in
                self?.loadFileList()
            }
            return
        }
        var files = [File]()
        // 遍历目录
        traverseDirectory(directoryPath: directoryPath) { (file) in
            files.append(file)
        }
        // 过滤文件
        for filter in filters {
            files = files.filter(filter)
        }
        // 排序文件
        if sort != nil {
            files = files.sorted(by: sort!)
        }
        
        DispatchQueue.main.async {
            self._list = files
            self.changeObserver.send(value: ListChange.reloadAll)
        }
    }
    
    
    func createDirectory(directoryName: String) {
        let path = directoryPath + "/" + directoryName
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            let file = File(path: path)
            DispatchQueue.main.async {
                self._list.insert(file, at: 0)
                self.changeObserver.send(value: ListChange.insert(indexs: [0]))
            }
        }
        catch {
            DispatchQueue.main.async {
                self.changeObserver.send(error: error as NSError)
            }
        }
    }
    
    /// 移动文件
    ///
    /// - Parameters:
    ///   - indexs: 文件索引
    ///   - directoryPath: 目标文件夹路径
    func moveFiles(for indexs: [Int], to directoryPath: String) {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory) && isDirectory.boolValue else {
            return
        }
        
        var successIndexs = [Int]()
        let files = self.files(for: indexs)
        for (idx, file) in files.enumerated() {
            let toPath = createFilePath(targetDirectory: directoryPath, lastPathComponent: file.path.lastPathComponent)
            do {
                try FileManager.default.moveItem(atPath: file.path, toPath: toPath)
                successIndexs.append(idx)
            }
            catch {
                
            }
        }
        remove(indexs: successIndexs)
    }
    
    /// 删除文件
    func deleteIndexs(idxs: [Int]) {
        guard idxs.count != 0 else {
            return
        }
        /// 删除成功的文件
        var successIndexs = [Int]()
        for idx in idxs {
            do {
                try FileManager.default.removeItem(atPath: list[idx].path)
                successIndexs.append(idx)
            }
            catch {
                
            }
        }
        guard successIndexs.count > 0 else {
            return
        }
        remove(indexs: successIndexs)
        changeObserver.send(value: ListChange.delete(indexs: successIndexs))
    }
    
    
    
    // MARK: Utils
    
    /// 获取当前文件列表中的照片
    func photos() -> [File] {
        return _list.filter({ (file) -> Bool in
            return file.type == .Photo
        })
    }
    
    /// 获取文件列表
    ///
    /// - Parameter indexs: 文件索引
    /// - Returns: <#return value description#>
    func files(for indexs: [Int]) -> [File] {
        var files = [File]()
        for idx in indexs {
            files.append(list[idx])
        }
        return files
    }
    
    /// 获取文件路径（解决重名的问题）
    ///
    /// - Parameter path: 目标文件路径
    private func createFilePath(targetPath: String) -> String {
        let name = targetPath.lastPathComponent.deletingPathExtension
        let directory = targetPath.deletingLastPathComponent
        let pathExtension = targetPath.pathExtension
        
        var flag = 1
        var newPath = targetPath
        while FileManager.default.fileExists(atPath: newPath) {
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
    
    /// 获取文件路径（解决重名的问题）
    ///
    /// - Parameters:
    ///   - targetDirectory: 目标文件夹路径
    ///   - lastPathComponent: 文件名称和后缀
    private func createFilePath(targetDirectory: String, lastPathComponent: String) -> String {
        let name = lastPathComponent.deletingPathExtension
        let pathExtension = lastPathComponent.pathExtension
        var flag = 1
        var newPath = targetDirectory + "/" + lastPathComponent
        while FileManager.default.fileExists(atPath: newPath) {
            if pathExtension == "" {
                newPath = targetDirectory + "/" + name + "(\(flag))"
            }
            else {
                newPath = targetDirectory + "/" + name + "(\(flag))." + pathExtension
            }
            flag += 1
        }
        return newPath
    }
    
    private func remove(indexs: [Int]) {
        let idxs = indexs.sorted {$0 < $1}
        var flag = 0
        for idx in idxs {
            _list.remove(at: idx - flag)
            flag += 1
        }
    }
    
}
