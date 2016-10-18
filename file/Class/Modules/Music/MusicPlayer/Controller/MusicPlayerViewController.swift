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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        
        view.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
        
        guard let internalTargets = self.navigationController?.interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray else { return }
        guard let internalTarget = internalTargets.lastObject as? NSObject else { return }
        guard let target = internalTarget.value(forKey: "target") else { return }
        let action = NSSelectorFromString("handleNavigationTransition:")
        panGestureRecognizer.addTarget(target, action: action)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }

}
