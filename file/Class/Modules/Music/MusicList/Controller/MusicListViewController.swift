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
    
    
    var testView = Menu()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "排序:日期", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MusicListViewController.sort))
        musicIndicator = ESTMusicIndicatorView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: musicIndicator)
        
        
        musicIndicator.state = .paused
        
        
        
        testView.navigationBarOffset = 64
        
        
        let titles = ["播放列表", "测试1111", "测试2222", "测试3333", "测试4444"]
        testView.dataSource = titles
        
        
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
        
        
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.orange
        scrollView.isPagingEnabled = true
//        scrollView.contentSize = CGSize(width: 300 + 100, height: 150)
        
        let view1 = UIView()
        view1.backgroundColor = UIColor.red
        
        let view2 = UIView()
        view2.backgroundColor = UIColor.green
        
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(150)
            make.center.equalTo(view)
        }
        view1.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height)
        }
        view2.snp.makeConstraints { (make) in
            make.left.equalTo(view1.snp.right)
            make.top.equalTo(scrollView)
            make.width.equalTo(100)
            make.height.equalTo(scrollView.snp.height)
        }
        scrollView.snp.makeConstraints { (make) in
            make.right.equalTo(view2.snp.right)
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
        if testView.isOpen {
            testView.close()
        }
        else {
            testView.show(view: view)
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
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 60
        tableView.register(MusicTableViewCell.classForCoder(), forCellReuseIdentifier: "Music")
        return tableView
    }()
    
}


