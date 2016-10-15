//
//  MusicListViewController.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import REMenu

class MusicListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var group: MusicGroup!
    
    var menu: REMenu!
    
    private var musicIndicator: ESTMusicIndicatorView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "音乐播放"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "排序:日期", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MusicListViewController.sort))
        musicIndicator = ESTMusicIndicatorView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: musicIndicator)
        
        
        musicIndicator.state = .paused
        
        
        
        
        
        
        let titles = ["播放列表", "测试1111", "测试2222", "测试3333", "测试4444"]
        var items = [REMenuItem]()
        for (idx, name) in titles.enumerated() {
            let item = REMenuItem(title: name, subtitle: nil, image: nil, backgroundColor: nil, highlightedImage: nil, action: { (item) in
                print("\(titles[item!.tag])")
            })!
            item.textColor = UIColor.white
            item.font = Font(18)
            item.tag = idx
            items.append(item)
        }
        
        let custView = UIView()
//        custView.backgroundColor = UIColor.orange
        let label = UILabel()
        label.font = Font(18)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "测试5555"
        custView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(custView.snp.width)
            make.height.equalTo(custView.snp.height)
            make.centerY.equalTo(0)
            make.left.equalTo(-40)
        }
        let but = UIButton(type: .system)
        but.backgroundColor = ColorRGB(r: 219, g: 92, b: 92)
        but.setTitle("删除", for: .normal)
        but.setTitleColor(UIColor.white, for: .normal)
        custView.addSubview(but)
        but.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(custView.snp.height)
            make.centerY.equalTo(0)
            make.right.equalTo(0)
        }
        
        
        let item = REMenuItem(customView: custView)!
        items.append(item)
        
        let createItem = REMenuItem(title: "创建分组", image: nil, backgroundColor: nil, highlightedImage: nil) { (item) in
            
        }!
        createItem.font = Font(18)
        createItem.backgroundColor = ColorRGB(r: 61, g: 168, b: 68)
        createItem.textColor = UIColor.white
        createItem.separatorColor = ColorRGB(r: 61, g: 168, b: 68)
        items.append(createItem)
        
        menu = REMenu(items: items)
//        menu.separatorOffset = CGSize(width: 15, height: 0)
        
        let button = UIButton(type: .system)
        button.setTitle("播放列表", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(MusicListViewController.toggleMenu), for: .touchUpInside)
        navigationItem.titleView = button
        /*
        navigationItem.titleView = MusicListNavigationTitleView(title: "播放列表", touchUpInside: { [weak self] in
            if self?.menu.isOpen == true {
                self?.menu.close()
            }
            else {
                self?.menu.show(from: self?.navigationController)
            }
        })*/
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        group = MusicGroup.default()
        
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
            menu.show(from: navigationController)
        }
    }
    func sort() {
        
    }
    
    
    // MARK: - Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.list().count
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Music") as! MusicTableViewCell
        let music = group.list()[indexPath.row]
        cell.setup(music: music, number: indexPath.row)
        
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
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 60
        tableView.register(MusicTableViewCell.classForCoder(), forCellReuseIdentifier: "Music")
        return tableView
    }()
    
}


