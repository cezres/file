//
//  FileViewController.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import VideoPlayer


/// 文件管理
class FileViewController: UIViewController, FileViewDelegate, FileToolBarDelegate {
    
    private var model: FileModel!
    
    private var fileView: FileView!
    private var toolBar: FileToolBar!

    init(directoryPath: String = DocumentDirectory) {
        super.init(nibName: nil, bundle: nil)
        if directoryPath == DocumentDirectory {
            title = "文件"
        }
        else {
            title = directoryPath.lastPathComponent
        }
        model = FileModel(directoryPath: directoryPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        initSubviews()
        
        model.loadFileList { [weak self]() in
            self?.fileView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarItem.title = title
    }
    
    
    // MARK: - FileToolBarDelegate
    func deleteItems() {
        let successIndexs = model.deleteIndexs(idxs: fileView.selectedIndexs())
        fileView.deleteItems(idxs: successIndexs)
        normalNavigationItem()
    }
    
    func moveItems() {
        
    }
    
    func copyItems() {
        
    }
    
    // MARK: - FileViewDelegate
    func fileView(fileView: FileView, didSelectedFile file: File) {
        if file.type == .Directory {
            /// 打开文件夹
            let controller = FileViewController(directoryPath: file.path)
            navigationController?.pushViewController(controller, animated: true)
        }
        else if file.type == .Video {
            /// 播放视频
            VideoPlayer.playVideo(with: file.url, title: file.name, in: self)
        }
        else if file.type == .Audio {
            /// 播放音频
            if let music = Music(url: file.url) {
                MusicPlayer.shared.play(music)
                MusicGroup.default().insert(music: music)
            }
        }
        else {
            /// 测试
            let url = URL(fileURLWithPath: DocumentDirectory + "/PV(1).flv")
            VideoPlayer.playVideo(with: url, title: "PV(1).flv", in: self)
        }
    }
    
    func list() -> [File] {
        return model.list
    }
    
    // MARK: - NavigationItem
    /// 正常状态的导航栏
    func normalNavigationItem() {
        let editButtonItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FileViewController.editNavigationItem))
        navigationItem.rightBarButtonItem = editButtonItem
        
        tabBarController?.tabBar.isHidden = false
        fileView.setEditing(editing: false)
        
        UIView.animate(withDuration: 0.3) {
            self.toolBar.transform.ty = 0
        }
    }
    /// 编辑状态的导航栏
    func editNavigationItem() {
        let normalButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.done, target: self, action: #selector(FileViewController.normalNavigationItem))
        navigationItem.rightBarButtonItem = normalButtonItem
        
        tabBarController?.tabBar.isHidden = true
        fileView.setEditing(editing: true)
        UIView.animate(withDuration: 0.3) {
            self.toolBar.transform.ty = -49
        }
    }
    
    /// 初始化子视图
    func initSubviews() {
        fileView = FileView()
        fileView.delegate = self
        view.addSubview(fileView)
        fileView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        toolBar = FileToolBar(delegate: self)
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(49)
        }
        
        normalNavigationItem()
    }
    
}
