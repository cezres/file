//
//  FileListServices.swift
//  file
//
//  Created by 翟泉 on 16/4/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileListServices {
    
    /**
     遍历目录
     
     - parameter directoryPath: 目录路径
     - parameter subDirectory:  遍历子目录
     - parameter callback:      回调
     */
    func traverseDirectory(directoryPath: String, subDirectory: Bool = false, callback: (file: File)->Void ) {
        
        do {
            let filenames = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(directoryPath)
            for filename in filenames {
                let path = directoryPath + "/" + filename
                let file = File(path: path)
                
                callback(file: file)
                
                if subDirectory && file.type == .Directory {
                    traverseDirectory(path, subDirectory: subDirectory, callback: callback)
                }
            }
        }
        catch {
            print(error)
        }
        
    }
    
}
