//
//  FileSelectViewController.swift
//  file
//
//  Created by 翟泉 on 2017/2/22.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit

class FileSelectViewController: UIViewController, FileContentViewDataSource, FileContentViewDelegate {
    
    
    class func selectDirectory(in controller: UIViewController, complete: (String) -> Void ) {
        let selectController = FileSelectViewController(directoryPath: DocumentDirectory)
        selectController.title = "选择文件夹"
        let navigationController = UINavigationController(rootViewController: selectController)
        controller.present(navigationController, animated: true) { 
            //
        }
    }
    
    private var model: FileModel!
    
    private var tableView: FileTableView!
    private var selectedInfoLabel: UILabel!
    
    private var confirmBlock: ( (String, UnsafeMutablePointer<ObjCBool>) -> Void )?
    
    
    private init(directoryPath: String) {
        super.init(nibName: nil, bundle: nil)
        model = FileModel(directoryPath: directoryPath)
        let filter = { (file: File) -> Bool in
            return file.type == .Directory
        }
        model.filters.append(filter)
        title = "文件选择"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard model != nil else {
            fatalError()
        }

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        let menuButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(FileSelectViewController.cancel))
        navigationItem.rightBarButtonItem = menuButtonItem
        
        initSubviews()
        
        model.loadFileList { [weak self] in
            self?.tableView.reload()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let navigationBar = navigationController?.navigationBar else { return }
        let frame = navigationBar.frame
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(frame.maxY)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedInfoLabel.text = "选择目录为:" + model.directoryPath.relativePath
    }
    
    func confirm() {
        guard let controller = navigationController?.viewControllers.last as? FileSelectViewController else { return }
        print(controller.model.directoryPath)
    }
    
    func newDir() {
        guard let controller = navigationController?.viewControllers.last as? FileSelectViewController else { return }
        print(controller.model.directoryPath)
        TextFieldAlertView.show(title: "新建文件夹", block: { (text) in
            print(text)
        })
    }
    
    func cancel() {
        navigationController?.dismiss(animated: true, completion: { 
            
        })
    }

    // MARK: FileContentViewDataSource
    func list() -> [File] {
        return model.list
    }
    
    func fileView(fileView: FileContentViewProtocol, didSelectIndex index: Int) {
        let file = model.list[index]
        navigationController?.pushViewController(FileSelectViewController(directoryPath: file.path), animated: true)
    }
    
    
    
    func initSubviews() {
        tableView = FileTableView(fileDataSource: self, fileDelegate: self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-70)
            make.top.equalTo(0)
        }
        
        initBottomView()
    }
    
    
    
    
    func initBottomView() {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            if let controller = navigationController?.viewControllers.first as? FileSelectViewController {
                self.selectedInfoLabel = controller.selectedInfoLabel
            }
            return
        }
        
        let selectedInfoLabel = UILabel()
        selectedInfoLabel.textAlignment = .center
        selectedInfoLabel.textColor = ColorRGB(0, 129, 246)
        selectedInfoLabel.backgroundColor = ColorWhite(180)
        selectedInfoLabel.font = Font(14)
        navigationController?.view.addSubview(selectedInfoLabel)
        self.selectedInfoLabel = selectedInfoLabel
        
        let bottomView = UIView()
        bottomView.backgroundColor = ColorWhite(80)
        navigationController?.view.addSubview(bottomView)
        
        let newDirButton = UIButton(type: .system)
        newDirButton.layer.cornerRadius = 4
        newDirButton.setTitle("新建文件夹", for: .normal)
        newDirButton.setTitleColor(UIColor.white, for: .normal)
        newDirButton.backgroundColor = ColorWhite(140)
        newDirButton.addTarget(self, action: #selector(FileSelectViewController.newDir), for: .touchUpInside)
        bottomView.addSubview(newDirButton)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.layer.cornerRadius = 4
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = ColorRGB(0, 129, 246)
        confirmButton.addTarget(self, action: #selector(FileSelectViewController.confirm), for: .touchUpInside)
        bottomView.addSubview(confirmButton)
        
        selectedInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(20)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(50)
        }
        newDirButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(bottomView.snp.centerX).offset(-5)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.left.equalTo(bottomView.snp.centerX).offset(5)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    
    
    
    
}
