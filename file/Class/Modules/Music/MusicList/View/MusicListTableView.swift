//
//  MusicListTableView.swift
//  file
//
//  Created by 翟泉 on 2016/10/25.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var list = [Music]() {
        didSet {
            reloadData()
        }
    }
    
    weak var cellDelegate: ButtonTableViewCellDelegate?
    
    init() {
        super.init(frame: CGRect(), style: .plain)
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
        rowHeight = 60
        register(MusicTableViewCell.classForCoder(), forCellReuseIdentifier: "Music")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Music") as! MusicTableViewCell
        let music = list[indexPath.row]
        cell.setup(music)
        cell.number = indexPath.row
        cell.delegate = cellDelegate
        
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
        MusicPlayer.shared.play(list: list, idx: indexPath.row)
    }

}
