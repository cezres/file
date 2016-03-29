//
//  ESHTTPServer.m
//  file
//
//  Created by 翟泉 on 16/3/1.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESHTTPServer.h"
#import "HTTPServer.h"
#import "ESNetworkInfo.h"
#import "ESHTTPConnection.h"

@interface ESHTTPServer ()
{
    HTTPServer *httpServer;
}
@end

@implementation ESHTTPServer

- (instancetype)init; {
    if (self = [super init]) {
        httpServer = [[HTTPServer alloc] init];
        [httpServer setType:@"_http._tcp."];
//        NSString *docRoot = [[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] stringByDeletingLastPathComponent];
//        NSString *docRoot = [[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"web"] stringByDeletingLastPathComponent];
//        [httpServer setDocumentRoot:docRoot];
        [httpServer setConnectionClass:[ESHTTPConnection class]];
    }
    return self;
}

+ (ESHTTPServer *)sharedInstance; {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)start; {
    if ([httpServer start:NULL]) {
        NSLog(@"%@  %@:%hu", [ESNetworkInfo WifiName], [ESNetworkInfo WiFiIPAddress], httpServer.port);
    }
}
- (void)stop; {
    [httpServer stop];
}


@end
