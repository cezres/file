//
//  FileViewController.swift
//  file
//
//  Created by 翟泉 on 2016/9/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
//import VideoPlayer
import ESMediaPlayer
import MBProgressHUD



/// 文件管理
class FileViewController: UIViewController, FileViewDelegate, FileToolBarDelegate, UIActionSheetDelegate {
    
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
        
        
        model.changeSignal.observe { [weak self](event) in
            guard event.error == nil else {
                HUDFailure(message: event.error!.domain)
                return
            }
            self?.fileView.change(for: event.value!)
            /*
            if event.value!.type == .reloadAll {
                self?.fileView.reloadData()
            }
            else if event.value!.type == .insert {
                self?.fileView.reloadData()
            }*/
        }
        model.loadFileList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarItem.title = title
    }
    
    
    // MARK: - FileToolBarDelegate
    func deleteItems() {
        let indexs = fileView.selectedIndexs()
        guard indexs.count > 0 else {
            return
        }
        model.deleteIndexs(idxs: indexs)
        normalNavigationItem()
    }
    
    func moveItems() {
        let indexs = fileView.selectedIndexs()
        guard indexs.count > 0 else {
            return
        }
        FileSelectViewController.selectDirectory(in: self) { (directoryPath) in
//            self.model.moveFiles(for: indexs, to: directoryPath)
        }
    }
    
    func copyItems() {
        FileSelectViewController.selectDirectory(in: self) { (directoryPath) in
            
        }
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
            if MusicPlayer.shared.state == .playing {
                MusicPlayer.shared.pause()
            }
            ESMediaPlayerViewController.player(with: file.url, title: file.name, in: self)
        }
        else if file.type == .Audio {
            /// 播放音频
            if MusicPlayer.shared.currentMusic?.url.path == file.path && MusicPlayer.shared.isPlaying {
                MusicPlayer.shared.pause()
            }
            else {
                navigationController?.pushViewController(MusicPlayerInfoViewController(url: file.url), animated: true)
            }
            /*
            UIApplication.shared.beginIgnoringInteractionEvents()
            Music.music(url: file.url, complete: { [weak self](music, error) in
                UIApplication.shared.endIgnoringInteractionEvents()
                guard let music = music else {
                    print(error!)
                    return
                }
                MusicPlayer.shared.play(music)
                MusicGroup.default.insert(music: music)
                self?.navigationController?.pushViewController(MusicPlayerInfoViewController(), animated: true)
            })*/
        }
        else if file.type == .Photo {
            let photos = model.photos()
            let idx = photos.index(of: file) ?? 0
            let urls: [URL] = photos.map({ (file) -> URL in
                return file.url
            })
            let controller = PhotoViewer(urls: urls, idx: idx)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func list() -> [File] {
        return model.list
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            TextFieldAlertView.show(title: "新建文件夹", block: { (text) in
                print(text)
                self.model.createDirectory(directoryName: text)
            })
        }
        else if buttonIndex == 2 {
            editNavigationItem()
        }
        else if buttonIndex == 3 {
            
        }
    }
    
    // MARK: - NavigationItem
    func onClickShowMenuItem() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "新建文件夹", "编辑", "排序")
        actionSheet.show(in: view)
    }
    func onClickSelAllItem() {
        
    }
    /// 正常状态的导航栏
    func normalNavigationItem() {
        let menuButtonItem = UIBarButtonItem(title: "菜单", style: .plain, target: self, action: #selector(FileViewController.onClickShowMenuItem))
        navigationItem.rightBarButtonItem = menuButtonItem
        if model.directoryPath == DocumentDirectory {
            let leftMenuItem = UIBarButtonItem(title: "更多", style: .plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
            navigationItem.leftBarButtonItem = leftMenuItem
        }
        else {
            navigationItem.leftBarButtonItem = nil
        }
        
        fileView.setEditing(editing: false)
        fileView.snp.updateConstraints { (make) in
            make.bottom.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.toolBar.transform.ty = 0
        }
    }
    /// 编辑状态的导航栏
    func editNavigationItem() {
        let normalButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(FileViewController.normalNavigationItem))
        navigationItem.rightBarButtonItem = normalButtonItem
        let selAllButtonItem = UIBarButtonItem(title: "全选", style: .plain, target: self, action: #selector(FileViewController.onClickSelAllItem))
        navigationItem.leftBarButtonItem = selAllButtonItem
        
        fileView.setEditing(editing: true)
        fileView.snp.updateConstraints { (make) in
            make.bottom.equalTo(-49)
        }
        
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
        
        guard model.directoryPath != DocumentDirectory else {
            return
        }
        guard let internalTargets = navigationController?.interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray else {
            return
        }
        guard let internalTarget = internalTargets.lastObject as? NSObject else {
            return
        }
        guard let target = internalTarget.value(forKey: "target") else {
            return
        }
        let action = NSSelectorFromString("handleNavigationTransition:")
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.maximumNumberOfTouches = 1
        fileView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(target, action: action)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
}
