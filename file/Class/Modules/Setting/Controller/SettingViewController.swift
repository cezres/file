//
//  SettingViewController.swift
//  file
//
//  Created by cezr on 16/6/23.
//  Copyright © 2016年 cezr. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "设置"
        view.backgroundColor = UIColor.white()
        
        let meunButtonItem = UIBarButtonItem(title: "菜单", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.presentLeftMenuViewController))
        navigationItem.leftBarButtonItems = [meunButtonItem]
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
