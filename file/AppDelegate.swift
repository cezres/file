//
//  AppDelegate.swift
//  file
//
//  Created by 翟泉 on 16/3/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

/*
private var once = UnsafeMutablePointer<dispatch_once_t>.alloc(1)

extension UINavigationController {
    public override class func initialize() {
        var i=0
        dispatch_once(once) { () -> Void in
            let originalMethod = class_getInstanceMethod(self, "viewDidLoad")
            let swizzledMethod = class_getInstanceMethod(self, "aop_viewDidLoad")
            if class_addMethod(self, "viewDidLoad", method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
                class_replaceMethod(self, "aop_viewDidLoad", method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }
            else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    func aop_viewDidLoad() {
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.aop_viewDidLoad()
    }
}
*/

extension UINavigationController {
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        let tabbar = UITabBarController()
//        tabbar.viewControllers = [
//            UINavigationController(rootViewController: ESFileListViewController()),
//            UINavigationController(rootViewController: ESDataTransferViewController()),
//            UINavigationController(rootViewController: ESSettingViewController()),
//        ]
//        tabbar.tabBar.tintColor = UIColor.blackColor()
        
        
        let nav = UINavigationController(rootViewController: ESFileListViewController())
        
        
        let sideMenuViewController = RESideMenu(contentViewController: nav, leftMenuViewController: ESMenuViewController(), rightMenuViewController: nil)
        sideMenuViewController.backgroundImage = UIImage(named: "MenuBackground")
        
        
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = sideMenuViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        print(url.absoluteString)
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(url.absoluteString)
        UIApplication.sharedApplication().openURL(NSURL(string: "fff://aswew/ewqeqw")!)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print(url.absoluteString)
        return true
    }

}

