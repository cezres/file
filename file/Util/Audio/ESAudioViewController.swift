//
//  ESAudioViewController.swift
//  file
//
//  Created by 翟泉 on 16/3/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import AVFoundation

class ESAudioViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer!
    var timer: NSTimer!
    var playInfo: ESAudioPlayerInfoView!
    
    init(path:String) {
        super.init(nibName: nil, bundle: nil)
        
//        do {
//            try AVAudioSession.sharedInstance().setActive(true)
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//        }
//        catch {
//            
//        }
        play(path)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view. 
        playInfo = ESAudioPlayerInfoView(frame: CGRect(x: (self.view.frame.width-260)/2, y: 200, width: 260, height: 100))
        view.addSubview(playInfo)
    }
    
    
    func play(path: String) {
        let url = NSURL(fileURLWithPath: path)
        do {
            
//            AudioQueueCreateTimeline(<#T##inAQ: AudioQueueRef##AudioQueueRef#>, <#T##outTimeline: UnsafeMutablePointer<AudioQueueTimelineRef>##UnsafeMutablePointer<AudioQueueTimelineRef>#>)
            
            player =  try AVAudioPlayer(contentsOfURL: url)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1
            player.numberOfLoops = 1
            player.play()
            
            
            
            player.meteringEnabled = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ESAudioViewController.time), userInfo: nil, repeats: true)
            
            
            print(player.settings)
        }
        catch {
            
        }
    }
    
    func time() {
        print(player.currentTime, " : ", player.duration, " : ", player.deviceCurrentTime)
        playInfo.progress = CGFloat(player.currentTime / player.duration)
        
        player.updateMeters()
        print(player.numberOfChannels)
        print(player.averagePowerForChannel(0), player.averagePowerForChannel(1))
        print(player.peakPowerForChannel(0), player.peakPowerForChannel(1))
    }
    
    
    // MARK: - AVAudioPlayerDelegate
    
}

class ESAudioPlayerInfoView: UIView {
    
    var progress: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        self .drawRect(rect, context: UIGraphicsGetCurrentContext()!)
    }
    func drawRect(rect: CGRect, context: CGContextRef) {
//        CGContextFillRect(context, rect)
        CGContextClearRect(context, rect)
        
        CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 1.0);
        CGContextSetLineWidth(context, 1.0);
        
        
        let strokeSegments = [
            CGPointMake(10.0, rect.height/2),
            CGPointMake(rect.width-10, rect.height/2)
        ]
        CGContextStrokeLineSegments(context, strokeSegments, 2);
        
        
        
        var strokeSegments2: [CGPoint] = []
        
        CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 1.0);
        CGContextSetLineWidth(context, 2.0);
        
        let offset: CGFloat = (rect.width - (2 * 32 + 31 * 2)) / 2;
        
        for i in 0 ..< 32 {
            strokeSegments2.append(CGPointMake(offset + CGFloat(i) * 4, 0))
            strokeSegments2.append(CGPointMake(offset + CGFloat(i) * 4, 20))
        }
        
        CGContextStrokeLineSegments(context, strokeSegments2, 64);
        
        
        
        
        CGContextAddEllipseInRect(context, CGRectMake(10 + (rect.size.width-20)*progress - 14,(rect.size.height-28)/2,28,28));
        CGContextSetFillColorWithColor(context, UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).CGColor);
        CGContextFillPath(context);
        
        
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.6);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddEllipseInRect(context, CGRectMake(10 + (rect.size.width-20)*progress - 14, (rect.size.height-28)/2,28,28));
        CGContextStrokePath(context);
        
        
        CGContextAddEllipseInRect(context, CGRectMake(10 + (rect.size.width-20)*progress - 4,(rect.size.height-8)/2,8,8));
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor);
        CGContextFillPath(context);
        
        
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        let dashPattern: [CGFloat] = [14,5]
        CGContextSetLineDash(context, progress * 50, dashPattern, 2);
        CGContextAddEllipseInRect(context, CGRectMake(10 + (rect.size.width-20)*progress - 6, (rect.size.height-12)/2, 12, 12));
        CGContextSetLineWidth(context, 2.0);
        CGContextStrokePath(context);
        
        
        
    }
}

