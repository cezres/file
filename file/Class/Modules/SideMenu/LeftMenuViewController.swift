//
//  LeftMenuViewController.swift
//  file
//
//  Created by 翟泉 on 2016/11/22.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit


class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    var dataSource = ["文件", "音乐", "视频", "照片", "设置"]
    
    lazy var fileController = UINavigationController(rootViewController: FileViewController(directoryPath: DocumentDirectory))
    lazy var musicController = UINavigationController(rootViewController: MyMusicViewController())
    lazy var settingController = UINavigationController(rootViewController: SettingViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fileController = sideMenuViewController.contentViewController as! UINavigationController
        
        tableView = UITableView(frame: CGRect(), style: .plain)
        tableView.rowHeight = 54
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(0)
            make.height.equalTo(54 * dataSource.count)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            sideMenuViewController.setContentViewController(fileController, animated: true)
            sideMenuViewController.hideViewController()
        }
        else if indexPath.row == 1 {
            sideMenuViewController.setContentViewController(musicController, animated: true)
            sideMenuViewController.hideViewController()
        }
        else if indexPath.row == 4 {
            sideMenuViewController.setContentViewController(settingController, animated: true)
            sideMenuViewController.hideViewController()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.highlightedTextColor = UIColor.lightGray
            cell?.selectedBackgroundView = UIView()
        }
        
        cell!.textLabel?.text = dataSource[indexPath.row]
        
        return cell!
        
    }
    

}
