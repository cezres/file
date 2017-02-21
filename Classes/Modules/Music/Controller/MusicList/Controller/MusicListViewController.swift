//
//  MusicListViewController.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import REMenu

class MusicListViewController: UIViewController, MusicGroupDelegate, ButtonTableViewCellDelegate {
    
    var group: MusicGroup!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        group = MusicGroup.default
    }
    
    init(musicGroup: MusicGroup) {
        super.init(nibName: nil, bundle: nil)
        group = musicGroup
    }
    
    init(groupName: String) {
        super.init(nibName: nil, bundle: nil)
        group = MusicGroup(name: groupName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "排序:日期", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MusicListViewController.sort))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: musicIndicator)
        
        
        group.delegate = self
        title = group.name
        
        
        // Do any additional setup after loading the view.
        group.list { [weak self](list, error) in
            self?.tableView.list = list
            self?.tableView.reloadData()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(MusicListViewController.handlePlayerStateChangedNotification), name: MusicPlayerNotification.stateChanged, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        handlePlayerStateChangedNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Event
    func sort() {
        
    }
    
    func tapMusicIndicator() {
        navigationController?.pushViewController(MusicPlayerInfoViewController(), animated: true)
    }
    
    // MARK: - Notification
    func handlePlayerStateChangedNotification() {
        if MusicPlayer.shared.state == .playing {
            musicIndicator.state = .playing
        }
        else {
            musicIndicator.state = .paused
        }
        
        group.list { [weak self](list, error) in
//            self?.tableView.list = list
            self?.tableView.reloadData()
        }
    }
    
    
    // MARK: - MusicGroupDelegate
    func musicGroup(group: MusicGroup, newMusic music: Music, insertMusicAt index: Int) {
        tableView.list.insert(music, at: index)
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .left)
    }
    
    func musicGroup(group: MusicGroup, deleteMusicAt index: Int) {
        tableView.list.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
    }
    
    // MARK: - ButtonTableViewCellDelegate
    func buttonCell(_ buttonCell: ButtonTableViewCell, onClickRightButtonAt index: Int) {
        group.delete(idx: index) { (error) in
            if error != nil {
                print(error.debugDescription)
            }
        }
    }
    
    lazy var tableView: MusicListTableView = {
        let tableView = MusicListTableView()
        tableView.cellDelegate = self
        return tableView
    }()
    
    
    private lazy var musicIndicator: ESTMusicIndicatorView = {
        let musicIndicator = ESTMusicIndicatorView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        musicIndicator.state = .paused
        let tap = UITapGestureRecognizer(target: self, action: #selector(MusicListViewController.tapMusicIndicator))
        musicIndicator.addGestureRecognizer(tap)
        return musicIndicator
    }()
    
}


