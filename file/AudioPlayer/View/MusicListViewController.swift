//
//  MusicListViewController.swift
//  file
//
//  Created by 翟泉 on 16/4/8.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "音频播放"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        view.backgroundColor = UIColor.whiteColor()
        
//        view.addSubview(tableView)
        
        AudioPlayerManager.sharedInstance.reloadSignal.subscribeNext { [unowned self](_) in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height-64-44)
        playerInfo.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    lazy var tableView: UITableView = {
        let lazy             = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        lazy.delegate        = self
        lazy.dataSource      = self
        lazy.backgroundColor = UIColor.whiteColor()
        lazy.separatorInset  = UIEdgeInsetsZero
        lazy.layoutMargins   = UIEdgeInsetsZero
        lazy.registerClass(MusicListTableViewCell.classForCoder(), forCellReuseIdentifier: "musicCell")
        self.view.addSubview(lazy)
        return lazy
    }()
    
    lazy var playerInfo: MusicPlayerInfoView = MusicPlayerInfoView()
}

extension MusicListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AudioPlayerManager.sharedInstance.playerQueue.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("musicCell")!
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if AudioPlayerManager.sharedInstance.playingIndex != -1 {
            return playerInfo
        }
        else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if AudioPlayerManager.sharedInstance.playingIndex != -1 {
            return playerInfo.frame.height
        }
        else {
            return 0
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let musicCell = cell as? MusicListTableViewCell else {
            return
        }
        musicCell.musicTitleLabel.text = AudioPlayerManager.sharedInstance.playerQueue[indexPath.row].name
        if AudioPlayerManager.sharedInstance.playingIndex == indexPath.row {
            if AudioPlayerManager.sharedInstance.state == .Playing {
                musicCell.state = .ESTMusicIndicatorViewStatePlaying
            }
            else {
                musicCell.state = .ESTMusicIndicatorViewStatePaused
            }
        }
        else {
            musicCell.state = .ESTMusicIndicatorViewStateStopped
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        AudioPlayerManager.sharedInstance.playingIndex = indexPath.row
    }
    
    
}



