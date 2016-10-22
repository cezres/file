//
//  MusicPlayerViewController.swift
//  file
//
//  Created by 翟泉 on 2016/10/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
//        backgrounView
//        artworkView
//        infoView
//        toolView
        view.addSubview(backgrounView)
        view.addSubview(artworkView)
        view.addSubview(infoView)
        view.addSubview(toolView)
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
        
        guard let internalTargets = self.navigationController?.interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray else { return }
        guard let internalTarget = internalTargets.lastObject as? NSObject else { return }
        guard let target = internalTarget.value(forKey: "target") else { return }
        let action = NSSelectorFromString("handleNavigationTransition:")
        panGestureRecognizer.addTarget(target, action: action)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPlayerViewController.handlePlayerStateChangedNotification), name: MusicPlayerNotification.stateChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPlayerViewController.handlePlayerMusicChangedNotification), name: MusicPlayerNotification.musicChanged, object: nil)
        
        handlePlayerMusicChangedNotification()
        handlePlayerStateChangedNotification()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Notification
    func handlePlayerStateChangedNotification() {
        let state = MusicPlayer.shared.state
        if state == .playing {
            infoView.start()
        }
        else if state == .paused {
            infoView.pause()
        }
        else if state == .stopped {
            infoView.stop()
        }
    }
    func handlePlayerMusicChangedNotification() {
        backgrounView.url = MusicPlayer.shared.currentMusic?.artworkURL
        artworkView.image = backgrounView.image
        
        infoView.songLabel.text = MusicPlayer.shared.currentMusic?.song
        infoView.singerLabel.text = MusicPlayer.shared.currentMusic?.singer
        infoView.currentTime = MusicPlayer.shared.currentTime
        infoView.duration = MusicPlayer.shared.duration
    }
    
    
    // MARK: - Lazy
    lazy var backgrounView: MusicPlayerBackgroudView = {
        let backgrounView = MusicPlayerBackgroudView()
        self.view.addSubview(backgrounView)
        backgrounView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        return backgrounView
    }()
    lazy var artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(0)
            make.top.equalTo(150)
        }
        return imageView
    }()
    lazy var toolView: MusicPlayerToolView = {
        let toolView = MusicPlayerToolView()
        self.view.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        return toolView
    }()
    lazy var infoView: MusicPlayerInfoView = {
        let infoView = MusicPlayerInfoView()
        self.view.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(self.artworkView.snp.bottom).offset(60)
            make.height.equalTo(150)
        }
        return infoView
    }()

}
