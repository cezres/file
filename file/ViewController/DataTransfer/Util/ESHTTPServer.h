//
//  ESHTTPServer.h
//  file
//
//  Created by 翟泉 on 16/3/1.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESHTTPServer : NSObject

+ (ESHTTPServer *)sharedInstance;

- (void)start;
- (void)stop;

@end
