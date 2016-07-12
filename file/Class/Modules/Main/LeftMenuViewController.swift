//
//  LeftMenuViewController.swift
//  file
//
//  Created by cezr on 16/6/23.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit


private let MenuItemTitles = ["文件管理", "音乐播放器", "设置"]


class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRect(), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isOpaque = true
        tableView.backgroundColor = UIColor.clear()
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(54 * MenuItemTitles.count)
        }
        
        
        fileListViewController = sideMenuViewController.contentViewController
    }
    
    
    var fileListViewController: UIViewController!
    var musicListViewController: UIViewController!
    var settingViewController: UIViewController!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItemTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            cell?.backgroundColor = UIColor.clear()
            cell?.selectedBackgroundView = UIView()
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell?.textLabel?.textColor = UIColor.white()
            cell?.textLabel?.highlightedTextColor = UIColor.lightGray()
        }
        
        cell?.textLabel?.text = MenuItemTitles[indexPath.row]
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        defer {
            sideMenuViewController.hideViewController()
        }
        
        if indexPath.row == 0 {
            if let nav = sideMenuViewController.contentViewController as? UINavigationController {
                if nav.viewControllers[0].classForCoder == FileListViewController.classForCoder() {
                    return
                }
            }
            if fileListViewController == nil {
                fileListViewController = UINavigationController(rootViewController: FileListViewController())
            }
            sideMenuViewController.contentViewController = fileListViewController
        }
        else if indexPath.row == 1 {
            if let nav = sideMenuViewController.contentViewController as? UINavigationController {
                if nav.viewControllers[0].classForCoder == MusicListViewController.classForCoder() {
                    return
                }
            }
            if musicListViewController == nil {
                musicListViewController = UINavigationController(rootViewController: MusicListViewController())
            }
            sideMenuViewController.contentViewController = musicListViewController
        }
        else if indexPath.row == 2 {
            if sideMenuViewController.contentViewController.classForCoder == SettingViewController.classForCoder() {
                return
            }
            if settingViewController == nil {
                settingViewController = UINavigationController(rootViewController: SettingViewController())
            }
            sideMenuViewController.contentViewController = settingViewController
        }
    }
    

}
