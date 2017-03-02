//
//  MusicListTableView.swift
//  file
//
//  Created by 翟泉 on 2016/10/25.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var list = [Music]()
    
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
    
    func reloadVisible() {
        for cell in visibleCells {
            if let indexPath = indexPath(for: cell) {
                tableView(self, willDisplay: cell, forRowAt: indexPath)
            }
        }
    }
    
    // MARK: - Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "Music") as! MusicTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let musicCell = cell as? MusicTableViewCell else { return }
        let music = list[indexPath.row]
        musicCell.setup(music)
        musicCell.number = indexPath.row
        if MusicPlayer.shared.currentMusic?.id == music.id {
            if MusicPlayer.shared.isPlaying {
                musicCell.state = .playing
            }
            else {
                musicCell.state = .paused
            }
        }
        else {
            musicCell.state = .stopped
        }
    }
    
    // MARK: - Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        MusicPlayer.shared.play(list: list, idx: indexPath.row)
    }

}
