//
//  FileModel.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation
import ReactiveSwift
import Zip

private let FileModelQueue = DispatchQueue(label: "FileModel")

class FileModel {
    
    // 目录路径
    let directoryPath: String
    // 文件列表
    var list: [File] {
        return _list
    }
    
    // 文件列表变更
    let changeSignal: Signal<ListChange, NSError>
    // 错误
    let errorSignal: Signal<NSError, NSError>
    
    private var _list = [File]()
    private let changeObserver: Observer<ListChange, NSError>
    private let errorObserver: Observer<NSError, NSError>
    
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
        (errorSignal, errorObserver) = Signal<NSError, NSError>.pipe()
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
        
        sendChange(change: ListChange.reloadAll) { 
            self._list = files
        }
    }
    
    
    /// 创建文件夹
    ///
    /// - Parameter directoryName: 文件夹名称
    func createDirectory(directoryName: String) {
        let path = directoryPath + "/" + directoryName
        var isDirectoryL: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectoryL) && isDirectoryL.boolValue {
            sendError(error: NSError(domain: "已存在文件夹", code: -1, userInfo: nil))
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            let file = File(path: path)
            sendChange(change: ListChange.insert(indexs: [0])) {
                self._list.insert(file, at: 0)
            }
        }
        catch {
            sendError(error: error as NSError)
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
                successIndexs.append(indexs[idx])
            }
            catch {
                
            }
        }
        sendChange(change: ListChange.delete(indexs: successIndexs)) {
            self.remove(indexs: successIndexs)
        }
    }
    
    /// 拷贝文件
    ///
    /// - Parameters:
    ///   - indexs: <#indexs description#>
    ///   - directoryPath: <#directoryPath description#>
    func copyFiles(for indexs: [Int], to directoryPath: String) {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDirectory) && isDirectory.boolValue else {
            return
        }
        let files = self.files(for: indexs)
        for file in files {
            let toPath = createFilePath(targetDirectory: directoryPath, lastPathComponent: file.path.lastPathComponent)
            do {
                try FileManager.default.copyItem(atPath: file.path, toPath: toPath)
            }
            catch {
                
            }
        }
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
        
        sendChange(change: ListChange.delete(indexs: successIndexs)) {
            self.remove(indexs: successIndexs)
        }
    }
    
    
    // MARK: Zip
    
    /// 解压缩
    ///
    /// - Parameter file: 压缩包文件
    /// - Throws: <#throws value description#>
    func unzipFile(file: File) throws {
        let destination = createFilePath(targetPath: directoryPath + "/" + file.name.deletingPathExtension)
        try Zip.unzipFile(file.url, destination: URL(fileURLWithPath: destination), overwrite: true, password: nil, progress: nil)
        let newFile = File(path: destination)
        let index = _list.index(of: file) ?? 0
        sendChange(change: ListChange.insert(indexs: [index]), changeBlock: {
            self._list.insert(newFile, at: index)
        })
    }
    
    /// 压缩文件
    ///
    /// - Parameter files: 需要压缩的文件
    /// - Throws: <#throws value description#>
    func zipFiles(files: [File]) throws {
        let urls = files.map { (file) -> URL in
            return file.url
        }
        let zipFilePath: String
        if files.count == 1 {
            zipFilePath = createFilePath(targetPath: directoryPath + "/" + files[0].name.deletingPathExtension + ".zip")
        }
        else {
            zipFilePath = createFilePath(targetPath: directoryPath + "/压缩文件.zip")
        }
        try Zip.zipFiles(paths: urls, zipFilePath: URL(fileURLWithPath: zipFilePath), password: nil, compression: .BestCompression, progress: nil)
        let newFile = File(path: zipFilePath)
        let index = (_list.index(of: files.last!) ?? 0) + 1
        sendChange(change: ListChange.insert(indexs: [index])) {
            self._list.insert(newFile, at: index)
        }
    }
    
    
    // MARK: Utils
    
    /// 获取当前文件列表中的照片
    func photos() -> [File] {
        return files(for: .Photo)
    }
    
    func files(for type: FileType) -> [File] {
        return _list.filter({ (file) -> Bool in
            return file.type == type
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
    
    private func sendChange(change: ListChange, changeBlock: (() -> Void)? = nil) {
        if Thread.isMainThread {
            changeBlock?()
            changeObserver.send(value: change)
        }
        else {
            DispatchQueue.main.async {
                changeBlock?()
                self.changeObserver.send(value: change)
            }
        }
    }
    
    private func sendError(error: NSError) {
        if Thread.isMainThread {
            errorObserver.send(value: error)
        }
        else {
            DispatchQueue.main.async {
                self.errorObserver.send(value: error)
            }
        }
    }
    
}
