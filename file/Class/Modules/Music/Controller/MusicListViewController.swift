//
//  MusicListViewController.swift
//  file
//
//  Created by 翟泉 on 2016/7/1.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var tableView: UITableView!
    
    let model = MusicPlayManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Music"
        
        let meunButtonItem = UIBarButtonItem(title: "菜单", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
        navigationItem.leftBarButtonItems = [meunButtonItem]
        
        tableView = UITableView(frame: CGRect(), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.register(MusicTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MusicListViewController.handlePanGesture(panGesture:)))
        panGesture.delegate = self
        tableView.addGestureRecognizer(panGesture)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        handlePlayStateChangedNotification()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default().addObserver(self, selector: #selector(MusicListViewController.handlePlayStateChangedNotification), name: PlayStateChangedNotification, object: nil)
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default().removeObserver(self)
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - GestureRecognizer
    
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let translationX =  panGesture.translation(in: view).x
        let progress = -(translationX / view.frame.width * 2)
        switch panGesture.state {
        case .began:
            MusicViewController.default.interactive = true
            present(MusicViewController.default, animated: true, completion: nil)
            break
        case .changed:
            MusicViewController.default.interactionController.update(progress>1 ? 1 : progress)
            break
        case .cancelled, .ended:
            MusicViewController.default.interactionController.completionSpeed = 0.99
            if progress > 0.5 {
                MusicViewController.default.interactionController.finish()
            }
            else {
                MusicViewController.default.interactionController.cancel()
            }
            MusicViewController.default.interactive = false
            break
        default:
            break
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer  else {
            return false
        }
        guard let translation: CGPoint = panGesture.translation(in: view) else {
            return false
        }
        print(translation)
        if translation.x >= 0 {
            return false
        }
        return true
    }
    
    func handlePlayStateChangedNotification() {
        tableView.reloadData()
    }

}




extension MusicListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.musicEntitys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "Cell")!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MusicTableViewCell else {
            return
        }
        cell.musicTitleLabel.text = model.musicEntitys[indexPath.row].name
        
        cell.state = .ESTMusicIndicatorViewStateStopped
        if MusicPlayManager.default.state == .Playing && model.musicEntitys[indexPath.row].path == MusicPlayManager.default.currentPlaying?.path {
            cell.state = .ESTMusicIndicatorViewStatePlaying
        }
        else if MusicPlayManager.default.state == .Paused && model.musicEntitys[indexPath.row].path == MusicPlayManager.default.currentPlaying?.path {
            cell.state = .ESTMusicIndicatorViewStatePaused
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if MusicPlayManager.default.currentPlaying?.path == MusicPlayManager.default.musicEntitys[indexPath.row].path {
            if MusicPlayManager.default.state == .Playing {
                MusicPlayManager.default.pause()
            }
            else {
                MusicPlayManager.default.play()
            }
        }
        else {
            MusicPlayManager.default.play(idx: indexPath.row)
        }
    }
    
}
