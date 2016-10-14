//
//  MusicPlayerToolView.swift
//  file
//
//  Created by 翟泉 on 2016/10/14.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicPlayerToolView: UIView {

    var playButton: UIButton!
    var nextButton: UIButton!
    var prevButton: UIButton!
    var playModeButton: UIButton!
    var moreButton: UIButton!
    
    
    init() {
        super.init(frame: CGRect())
        backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        initSubviews()
        handlePlayStateChangedNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(MusicPlayerToolView.handlePlayStateChangedNotification), name: MusicPlayerNotification.stateDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickPlay() {
        if MusicPlayer.shared.state == .playing {
            MusicPlayer.shared.pause()
        }
        else {
            MusicPlayer.shared.play()
        }
    }
    
    func clickNext() {
        //        MusicPlayer.shared.next()
    }
    
    func clickPrev() {
        //        MusicPlayer.shared.prev()
    }
    
    func handlePlayStateChangedNotification() {
        if MusicPlayer.shared.state == .playing {
            playButton.setImage(#imageLiteral(resourceName: "icon-pause"), for: UIControlState(rawValue: 0))
        }
        else if MusicPlayer.shared.state == .paused {
            playButton.setImage(#imageLiteral(resourceName: "icon-play"), for: UIControlState(rawValue: 0))
        }
        else if MusicPlayer.shared.state == .stopped {
            playButton.setImage(#imageLiteral(resourceName: "icon-play"), for: UIControlState(rawValue: 0))
        }
    }
    
    func initSubviews() {
        
        playButton = UIButton(type: UIButtonType.system)
        playButton.addTarget(self, action: #selector(MusicPlayerToolView.clickPlay), for: UIControlEvents.touchUpInside)
        playButton.tintColor = UIColor.white
        playButton.setImage(#imageLiteral(resourceName: "icon-play"), for: UIControlState(rawValue: 0))
        addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        nextButton = UIButton(type: UIButtonType.system)
        nextButton.addTarget(self, action: #selector(MusicPlayerToolView.clickNext), for: UIControlEvents.touchUpInside)
        nextButton.tintColor = UIColor.white
        nextButton.setImage(#imageLiteral(resourceName: "icon-next"), for: UIControlState(rawValue: 0))
        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(playButton.snp.right).offset(15)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        prevButton = UIButton(type: UIButtonType.system)
        prevButton.addTarget(self, action: #selector(MusicPlayerToolView.clickPrev), for: UIControlEvents.touchUpInside)
        prevButton.tintColor = UIColor.white
        prevButton.setImage(#imageLiteral(resourceName: "icon-prev"), for: UIControlState(rawValue: 0))
        addSubview(prevButton)
        prevButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(playButton.snp.left).offset(-15)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        playModeButton = UIButton(type: UIButtonType.system)
        //        playModeButton.addTarget(self, action: #selector(MusicToolView.clickPrev), for: UIControlEvents.touchUpInside)
        playModeButton.tintColor = UIColor.white
        playModeButton.setImage(#imageLiteral(resourceName: "icon_loopAll"), for: UIControlState(rawValue: 0))
        addSubview(playModeButton)
        playModeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        moreButton = UIButton(type: UIButtonType.system)
        //        moreButton.addTarget(self, action: #selector(MusicToolView.clickPrev), for: UIControlEvents.touchUpInside)
        moreButton.tintColor = UIColor.white
        moreButton.setImage(#imageLiteral(resourceName: "icon_more"), for: UIControlState(rawValue: 0))
        addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
    }

}
