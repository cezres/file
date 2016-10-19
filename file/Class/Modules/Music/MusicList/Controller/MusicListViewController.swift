//
//  MusicListViewController.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import REMenu

class MusicListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuDelegate, MusicGroupDelegate, ButtonTableViewCellDelegate {
    
    var group: MusicGroup! {
        didSet {
            titleView.setTitle(group.name, for: .normal)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "音乐播放"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var menu = Menu()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "排序:日期", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MusicListViewController.sort))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: musicIndicator)
        
        menu.navigationBarOffset = 64
        menu.delegate = self
        
        group = MusicGroup.default()
        navigationItem.title = group.name
        
        
        var items = [MenuItem]()
        for name in MusicGroup.groupNames() {
            let button = UIButton(type: .system)
            button.setTitle("删除", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = ColorRGB(253, 85, 98)
            
            let item = MenuItem()
            item.title = name
            item.rightButtons = [button]
            items.append(item)
        }
        
        let newItem = MenuItem()
        newItem.title = "创建分组"
        newItem.textColor = UIColor.white
        newItem.backgroundColor = ColorRGB(61, 168, 68)
        newItem.isHiddenSeparatorView = true
        
        items.append(newItem)
        
        menu.items = items
        
        
        
        
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Event
    func toggleMenu() {
        if menu.isOpen {
            menu.close()
        }
        else {
            menu.show(view: view)
        }
    }
    func sort() {
        
    }
    func tapMusicIndicator() {
        let controller = MusicPlayerViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - MenuDelegate
    func menu(_ menu: Menu, didSelectRowAt index: Int) {
        if index == menu.items.count - 1 {
            TextFieldAlertView.show(title: "创建播放列表", block: { (name) in
                print(name)
                if MusicGroup.create(name: name) {
                    let button = UIButton(type: .system)
                    button.setTitle("删除", for: .normal)
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.backgroundColor = ColorRGB(253, 85, 98)
                    
                    let item = MenuItem()
                    item.title = name
                    item.rightButtons = [button]
                    menu.insertItem(item, at: menu.items.count-1)
                }
                else {
                    print("创建表失败")
                }
            })
        }
        else {
            let item = menu.items[index]
            group = MusicGroup(name: item.title!)
            tableView.reloadData()
            menu.close()
        }
    }
    func menu(_ menu: Menu, itemIndex: Int, onClickRightButtonAt buttonIndex: Int) {
        print(menu.items[itemIndex].title!)
        if MusicGroup.delete(name: menu.items[itemIndex].title!) {
            menu.removeItem(idx: itemIndex)
        }
        else {
            print("删除表失败")
        }
    }
    
    // MARK: - MusicGroupDelegate
    func musicGroup(group: MusicGroup, insertMusicAt index: Int) {
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    func musicGroup(group: MusicGroup, deleteMusicAt index: Int) {
        
    }
    
    // MARK: - ButtonTableViewCellDelegate
    func buttonCell(_ buttonCell: ButtonTableViewCell, onClickRightButtonAt index: Int) {
        if group.delete(idx: index) {
            
        }
        else {
            print("")
        }
    }
    
    // MARK: - Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.list().count
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Music") as! MusicTableViewCell
        let music = group.list()[indexPath.row]
        cell.setup(music)
        cell.number = indexPath.row
        
        if MusicPlayer.shared.currentMusic?.id == music.id {
            if MusicPlayer.shared.isPlaying {
                cell.state = .playing
            }
            else {
                cell.state = .paused
            }
        }
        else {
            cell.state = .stopped
        }
        
        return cell
    }
    // MARK: - Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let music = group.list()[indexPath.row]
        MusicPlayer.shared.play(music)
        
        var idxPaths = [IndexPath]()
        for cell in tableView.visibleCells {
            if let idx = tableView.indexPath(for: cell) {
                idxPaths.append(idx)
            }
        }
        tableView.reloadRows(at: idxPaths, with: .none)
        
        let controller = MusicPlayerViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 60
        tableView.register(MusicTableViewCell.classForCoder(), forCellReuseIdentifier: "Music")
        return tableView
    }()
    
    
    private lazy var musicIndicator: ESTMusicIndicatorView = {
        let musicIndicator = ESTMusicIndicatorView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        musicIndicator.state = .paused
        let tap = UITapGestureRecognizer(target: self, action: #selector(MusicListViewController.tapMusicIndicator))
        musicIndicator.addGestureRecognizer(tap)
        return musicIndicator
    }()
    
    private lazy var titleView: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(MusicListViewController.toggleMenu), for: .touchUpInside)
        self.navigationItem.titleView = button
        return button
    }()
    
}


