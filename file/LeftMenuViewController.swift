//
//  LeftMenuViewController.swift
//  file
//
//  Created by 翟泉 on 16/5/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import RESideMenu

class LeftMenuViewController: UIViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        let autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.FlexibleTopMargin.rawValue | UIViewAutoresizing.FlexibleBottomMargin.rawValue | UIViewAutoresizing.FlexibleWidth.rawValue)
        tableView.autoresizingMask = autoresizingMask
        tableView.dataSource = self
        tableView.delegate = self
        tableView.opaque = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.bounces = false
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = CGRectMake(0, (view.frame.height - 54*4) / 2.0, view.frame.width, 54*4)
        super.viewWillLayoutSubviews()
    }
    
}

extension LeftMenuViewController: RESideMenuDelegate {
    
    func sideMenu(sideMenu: RESideMenu!, didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        
    }
    
}


extension LeftMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectedBackgroundView = UIView()
            cell?.textLabel?.font = Font(21)
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.textLabel?.highlightedTextColor = UIColor.lightGrayColor()
        }
        
        let titles = ["文件管理", "音乐播放器", "数据传输", "设置"]
        
        cell?.textLabel?.text = titles[indexPath.row]
        
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        defer {
            sideMenuViewController.hideMenuViewController()
        }
        
        if indexPath.row == 0 {
            if let nav = sideMenuViewController.contentViewController as? UINavigationController {
                if nav.viewControllers[0].classForCoder == FileListViewController.classForCoder() {
                    return
                }
            }
            sideMenuViewController.contentViewController = UINavigationController(rootViewController: FileListViewController())
        }
        else if indexPath.row == 3 {
            if sideMenuViewController.contentViewController.classForCoder == SettingViewController.classForCoder() {
                return
            }
            sideMenuViewController.contentViewController = UINavigationController(rootViewController: SettingViewController())
        }
    }
}