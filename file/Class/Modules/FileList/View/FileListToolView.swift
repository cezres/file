//
//  FileListToolView.swift
//  file
//
//  Created by 翟泉 on 2016/7/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

protocol FileListToolViewDelegate: NSObjectProtocol {
    
    func deleteFile()
    
    func moveFile()
    
    func copyFile()
    
    func compressFile()
    
}

class FileListToolView: UIView {
    
    weak var delegate: FileListToolViewDelegate?
    
    init() {
        super.init(frame: CGRect())
        backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        let titles = ["Copy", "Move", "Delete", "Compress"]
        
        var left = snp_left
        for idx in 0..<titles.count {
            let button = UIButton(type: UIButtonType.system)
            button.tag = idx
            button.setTitle(titles[idx], for: UIControlState(rawValue: 0))
            button.addTarget(self, action: #selector(FileListToolView.handleEvent(button:)), for: UIControlEvents.touchUpInside)
            addSubview(button)
            button.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(left)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.width.equalTo(snp_width).dividedBy(titles.count)
            })
            left = button.snp_right
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleEvent(button: UIButton) {
        switch button.tag {
        case 0:
            delegate?.copyFile()
        case 1:
            delegate?.moveFile()
        case 2:
            delegate?.deleteFile()
        case 3:
            delegate?.compressFile()
        default:
            return
        }
    }

}
