//
//  SettingViewController.swift
//  file
//
//  Created by 翟泉 on 2016/9/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import RESideMenu

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var groups = [["清理缓存"]]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "设置"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftMenuItem = UIBarButtonItem(title: "菜单", style: .done, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
        navigationItem.leftBarButtonItem = leftMenuItem
        
        view.backgroundColor = UIColor.white
        
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do {
            try FileManager.default.removeItem(atPath: CachesDirectory + "/ImageTables")
        }
        catch {
            
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = groups[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    

    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: UITableViewStyle.grouped)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 60
        return tableView
    }()

}
