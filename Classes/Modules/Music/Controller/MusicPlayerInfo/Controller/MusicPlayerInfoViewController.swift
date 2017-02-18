//
//  MusicPlayerInfoViewController.swift
//  file
//
//  Created by 翟泉 on 2017/2/18.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

import UIKit

class MusicPlayerInfoViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        infoView.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        initSubviews()
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
        
        guard let internalTargets = self.navigationController?.interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray else { return }
        guard let internalTarget = internalTargets.lastObject as? NSObject else { return }
        guard let target = internalTarget.value(forKey: "target") else { return }
        let action = NSSelectorFromString("handleNavigationTransition:")
        panGestureRecognizer.addTarget(target, action: action)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MusicPlayerInfoViewController.popController))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPlayerInfoViewController.handlePlayerStateChangedNotification), name: MusicPlayerNotification.stateChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPlayerInfoViewController.handlePlayerMusicChangedNotification), name: MusicPlayerNotification.musicChanged, object: nil)
        
        handlePlayerMusicChangedNotification()
        handlePlayerStateChangedNotification()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popController() {
        _ = navigationController?.popViewController(animated: true)
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
        backgrounView.image = MusicPlayer.shared.currentMusic?.artwork
        artworkView.image = backgrounView.image
        
        infoView.songLabel.text = MusicPlayer.shared.currentMusic?.song
        infoView.singerLabel.text = MusicPlayer.shared.currentMusic?.singer
        infoView.currentTime = MusicPlayer.shared.currentTime
        infoView.duration = MusicPlayer.shared.duration
    }
    
    
    func initSubviews() {
        view.addSubview(backgrounView)
        view.addSubview(artworkView)
        view.addSubview(infoView)
        view.addSubview(toolView)
        
        backgrounView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        artworkView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(150)
        }
        toolView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        infoView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(self.artworkView.snp.bottom).offset(60)
            make.height.equalTo(150)
        }
    }
    
    // MARK: - Lazy
    lazy var backgrounView: MusicPlayerBackgroudView = {
        return MusicPlayerBackgroudView()
    }()
    lazy var artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    lazy var toolView: MusicPlayerToolView = {
        return MusicPlayerToolView()
    }()
    lazy var infoView: MusicPlayerInfoView = {
        return MusicPlayerInfoView()
    }()

}
