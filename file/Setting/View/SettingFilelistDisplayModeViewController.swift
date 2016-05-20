//
//  SettingFilelistDisplayModeViewController.swift
//  file
//
//  Created by 翟泉 on 16/5/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class SettingFilelistDisplayModeViewController: UIViewController {
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        view.backgroundColor = UIColor.whiteColor()
        title = "设置文件列表显示模式"
        
        
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        view.addSubview(tableView)
        
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = CGRectMake(0, 64, view.frame.width, view.frame.height-64)
        super.viewWillLayoutSubviews()
    }

}


extension SettingFilelistDisplayModeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "列表"
        }
        else {
            cell?.textLabel?.text = "图标"
        }
        
        if indexPath.row == SettingServices.sharedInstance.filelistDisplayMode.rawValue {
            cell?.textLabel?.textColor = UIColor.redColor()
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "文件列表显示模式"
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        SettingServices.sharedInstance.filelistDisplayMode = FilelistDisplayMode(rawValue: indexPath.row) ?? .TableView
        
        navigationController?.popViewControllerAnimated(true)
    }
}
