//
//  RootViewController.swift
//  file
//
//  Created by cezr on 16/6/23.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu {

    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        contentViewController = UINavigationController(rootViewController: FileListViewController())
        leftMenuViewController = LeftMenuViewController()
        
        backgroundImage = UIImage(named: "MenuBackground")
        scaleBackgroundImageView = false
        scaleContentView = false
        scaleMenuView = false
        panMinimumOpenThreshold = 60
        panFromEdge = false
        
        super.viewDidLoad()
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

}
