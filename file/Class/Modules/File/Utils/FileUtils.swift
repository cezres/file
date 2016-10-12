//
//  FileUtils.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import Foundation


typealias FileCallback = (_ file: File) -> Void

/**
 遍历目录
 
 - parameter directoryPath: 目录路径
 - parameter subDirectory:  是否遍历子目录
 - parameter callback:      回调
 */
func traverseDirectory(directoryPath: String, subDirectory: Bool = false, callback: FileCallback) {
    do {
        let contents = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
        for content in contents {
            let filePath = directoryPath + "/" + content
            let file = File(path: filePath)
            callback(file)
            if subDirectory && file.type == FileType.Directory {
                traverseDirectory(directoryPath: filePath, subDirectory: true, callback: callback)
            }
        }
    }
    catch {
        
    }
}





