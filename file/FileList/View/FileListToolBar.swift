//
//  FileListToolBar.swift
//  file
//
//  Created by 翟泉 on 16/4/25.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


@objc protocol FileListToolBarDelegate {
    func delete()
    func move()
    func copy()
}


class FileListToolBar: UIToolbar {
    
    weak var toolDelegate: FileListToolBarDelegate?
    
    init() {
        super.init(frame: CGRectMake(0, SSize.height, SSize.width, 49))
        
        backgroundColor = UIColor.whiteColor()
        
        let deleteItem = UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListToolBar.deleteFile))
        let moveItem = UIBarButtonItem(title: "移动", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListToolBar.moveFile))
        let copyItem = UIBarButtonItem(title: "复制", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FileListToolBar.copyFile))
        
        items = [deleteItem, moveItem, copyItem]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var show: Bool = false {
//        get {
//            return y != SSize.height
//        }
//        set {
////            if newValue {
////                transform = CGAffineTransformTranslate(transform, 0, SSize.height-49 - y)
////            }
////            else {
////                transform = CGAffineTransformTranslate(transform, 0, SSize.height - y)
////            }
////            hidden = !newValue
//        }
        didSet {
            
        }
    }
    
    func deleteFile() {
        toolDelegate?.delete()
    }
    
    func moveFile() {
        toolDelegate?.move()
    }
    
    func copyFile() {
        toolDelegate?.copy()
    }

}
