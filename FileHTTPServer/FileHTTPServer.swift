//
//  FileHTTPServer.swift
//  file
//
//  Created by 翟泉 on 16/5/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit
//import CocoaLumberjack
//import CocoaHTTPServer


public class FileHTTPServer {
    
    public static let sharedInstance = FileHTTPServer()
    
    public init() {
        
    }
    
    public func start() {
        
        print(ESNetworkInfo.WiFiIPAddress())
        
        let bundle = NSBundle(forClass: FileHTTPConnection.classForCoder())
        
        let path = bundle.pathForResource("favicon-20160420113110563", ofType: "ico")
        
        let data = NSData(contentsOfFile: path!)
        
        
    }
    
}
