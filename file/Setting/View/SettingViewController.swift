//
//  SettingViewController.swift
//  file
//
//  Created by 翟泉 on 16/5/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        view.backgroundColor = UIColor.whiteColor()
        title = "设置"
        
        if self.navigationController?.viewControllers.count == 1 {
            let meunButtonItem = UIBarButtonItem(title: "菜单", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
            navigationItem.leftBarButtonItems = [meunButtonItem]
        }
        else {
            navigationItem.leftBarButtonItems = []
        }
        
        
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
//        let autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.FlexibleTopMargin.rawValue | UIViewAutoresizing.FlexibleBottomMargin.rawValue | UIViewAutoresizing.FlexibleWidth.rawValue)
//        tableView.autoresizingMask = autoresizingMask
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.opaque = true
//        tableView.backgroundColor = UIColor.clearColor()
//        tableView.backgroundView = nil
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.bounces = false
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        if tableView.visibleCells.count > 0 {
            tableView.reloadData()
        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = CGRectMake(0, 64, view.frame.width, view.frame.height-64)
        super.viewWillLayoutSubviews()
    }
    
    
    var titles = ["文件管理", "音乐播放器", "数据传输", "设置"]
    
    var dataSource = [
        [
            "显示模式", "排序"
        ],
        
        [
//            "显示模式", "排序"
        ],
        
        [
//            "显示模式"
        ],
        
        [
            "清理缓存"
        ]
    ]
    
}



extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = SettingServices.sharedInstance.filelistDisplayMode.description
            }
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                navigationController?.pushViewController(SettingFilelistDisplayModeViewController(), animated: true)
            }
        }
        
    }
}
