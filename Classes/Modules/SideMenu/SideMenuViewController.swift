//
//  SideMenuViewController.swift
//  file
//
//  Created by 翟泉 on 2016/11/22.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
import RESideMenu

class SideMenuViewController: RESideMenu, RESideMenuDelegate {
    
    
    init() {
//        let contentViewController = FileViewController()
        let contentViewController = UINavigationController(rootViewController: SettingViewController())
        
        let leftMenuViewController = LeftMenuViewController()
        
        super.init(contentViewController: contentViewController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    
    // MARK: - RESideMenuDelegate
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
