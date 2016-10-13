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
        
        print(group.list())
        
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        let music = group.list()[indexPath.row]
        cell?.textLabel?.text = music.song
        cell?.detailTextLabel?.text = "播放:\(music.playCount)"
        return cell!
    }
    // MARK: - Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let music = group.list()[indexPath.row]
        MusicPlayer.share.play(url: music.url)
    }
    

    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 60
        return tableView
    }()
    
}


