//
//  MyMusicViewController.swift
//  file
//
//  Created by 翟泉 on 2016/11/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MyMusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var model: MyMusicModel!
    
    var searchControl: MusicSearchControl!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "我的音乐"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        model = MyMusicModel()
        
        
        searchControl = MusicSearchControl(navigationItem: navigationItem, contentInView: view)
        
        let moreButtonItem = UIBarButtonItem(title: "更多", style: .done, target: self, action: #selector(MyMusicViewController.onClickMoreItem))
        navigationItem.leftBarButtonItem = moreButtonItem
        
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func onClickMoreItem() {
        
    }
    
    // MARK: - UITableView Protocol
    /// Number
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.groups.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.groups[section].contents.count
    }
    /// Size
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return model.groups[section].title == nil ? 0 : 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    /// Cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! MyMusicHeaderView
        headerView.textLabel?.text = model.groups[section].title
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyMusicTableViewCell
        cell.textLabel?.text = model.groups[indexPath.section].contents[indexPath.row]
        return cell
    }
    /// Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyMusicTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(MyMusicHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "header")
        return tableView
    }()
    
}
