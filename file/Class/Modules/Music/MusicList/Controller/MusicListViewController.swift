//
//  MusicListViewController.swift
//  file
//
//  Created by 翟泉 on 2016/10/9.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var group: MusicGroup!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "音乐播放"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


