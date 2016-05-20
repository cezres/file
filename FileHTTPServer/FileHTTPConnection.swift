//
//  FileHTTPConnection.swift
//  file
//
//  Created by 翟泉 on 16/5/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class FileHTTPConnection: HTTPConnection {
    
    
    
    override func httpResponseForMethod(method: String!, URI path: String!) -> protocol<NSObjectProtocol, HTTPResponse>! {
        
        guard method != nil && path != nil else {
            return super.httpResponseForMethod(method, URI: path)
        }
        
        
        
        
        
        if path == "/favicon.ico" {
            return HTTPDataResponse(data: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("favicon-20160420113110563", ofType: "ico")!)!)
        }
        
        return super.httpResponseForMethod(method, URI: path)
    }
    
    
}
