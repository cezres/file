//
//  FileToolBar.swift
//  file
//
//  Created by 翟泉 on 2016/9/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


protocol FileToolBarDelegate: NSObjectProtocol {
    
    func deleteItems()
    
    func moveItems()
    
    func copyItems()
    
}

class FileToolBar: UIToolbar {
    
    var fileDelegate: FileToolBarDelegate?
    
    init(delegate: FileToolBarDelegate) {
        super.init(frame: CGRect())
        fileDelegate = delegate
        backgroundColor = ColorWhite(white: 247)
        let deleteBarButton = UIBarButtonItem(title: "    删除    ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FileToolBar.deleteItems))
        let moveBarButton = UIBarButtonItem(title: "    移动    ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FileToolBar.moveItems))
        let copyBarButton = UIBarButtonItem(title: "    复制    ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FileToolBar.copyItems))
        items = [deleteBarButton, moveBarButton, copyBarButton]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deleteItems() {
        print(#function)
        fileDelegate?.deleteItems()
    }
    
    func moveItems() {
        print(#function)
        fileDelegate?.moveItems()
    }
    
    func copyItems() {
        print(#function)
        fileDelegate?.copyItems()
    }
    
}
