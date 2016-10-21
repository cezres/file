//
//  MusicPlayerViewController.swift
//  file
//
//  Created by 翟泉 on 2016/10/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    
    
    let toolView = MusicPlayerToolView()
    let infoView = MusicPlayerInfoView()
    
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
        
        
        
        
        
        
        let backgrounView = MusicPlayerBackgroudView()
        view.addSubview(backgrounView)
        backgrounView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        backgrounView.url = MusicPlayer.shared.currentMusic?.artworkURL
        
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.image = backgrounView.image
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(0)
            make.top.equalTo(150)
        }
        
        
        view.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        
        view.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(imageView.snp.bottom).offset(60)
            make.height.equalTo(150)
        }
        
        
        
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
        
        guard let internalTargets = self.navigationController?.interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray else { return }
        guard let internalTarget = internalTargets.lastObject as? NSObject else { return }
        guard let target = internalTarget.value(forKey: "target") else { return }
        let action = NSSelectorFromString("handleNavigationTransition:")
        panGestureRecognizer.addTarget(target, action: action)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPlayerViewController.handlePlayStateChangedNotification), name: MusicPlayerNotification.stateDidChange, object: nil)
        handlePlayStateChangedNotification()
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
    
    func handlePlayStateChangedNotification() {
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

}
