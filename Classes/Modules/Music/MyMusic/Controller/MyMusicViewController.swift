//
//  MyMusicViewController.swift
//  file
//
//  Created by 翟泉 on 2016/11/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MyMusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var model: MyMusicModel!
    
    var groups = [MyMusicGroupEntity]()
    
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
        
        let defaultGroup = MyMusicGroupEntity()
        defaultGroup.title = "默认分组"
        defaultGroup.contents = ["下载音乐", "最近播放", "我的听歌排行", "本地音乐"]
        
        let userGroup = MyMusicGroupEntity()
        userGroup.title = "我创建的歌单"
        userGroup.contents = MusicGroup.groupNames()
        groups = [defaultGroup, userGroup]
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "更多", style: .plain, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(MyMusicViewController.onClickSearch))
        
        
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
        groups[1].contents = MusicGroup.groupNames()
        tableView.reloadSections(IndexSet(integersIn: 1...1), with: .automatic)
    }
    
    
    func onClickMoreItem() {
        
    }
    
    func onClickSearch() {
        
    }
    
    
    // MARK: - UITableView Protocol
    /// Number
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].contents.count
    }
    /// Size
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return groups[section].title == nil ? 0 : 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    /// Cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! MyMusicHeaderView
        headerView.textLabel?.text = groups[section].title
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyMusicTableViewCell
        cell.textLabel?.text = groups[indexPath.section].contents[indexPath.row]
        return cell
    }
    /// Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let musicGroup = MusicGroup(name: groups[indexPath.section].contents[indexPath.row])
            let musicList = MusicListViewController(musicGroup: musicGroup)
            navigationController?.pushViewController(musicList, animated: true)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyMusicTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(MyMusicHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "header")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
}
