//
//  FileHTTPServer.m
//  file
//
//  Created by 翟泉 on 16/5/21.
//  Copyright © 2016年 云之彼端. All rights reserved.
//


#import "FileHTTPServer.h"
#import "HTTPServer.h"
#import "FileHTTPConnection.h"

#import "NetworkInfo.h"

@interface FileHTTPServer ()
{
    HTTPServer *httpServer;
}
@end

@implementation FileHTTPServer

+ (FileHTTPServer *)sharedInstance; {
    static FileHTTPServer * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init; {
    if (self = [super init]) {
        httpServer = [[HTTPServer alloc] init];
        [httpServer setType:@"_http._tcp."];
        [httpServer setConnectionClass:[FileHTTPConnection class]];
    }
    return self;
}

- (BOOL)networkValid; {
    return [[NetworkInfo WiFiIPAddress] length];
}

- (BOOL)start; {
    if (httpServer.isRunning) {
        return YES;
    }
    [httpServer setPort:22333];
    [httpServer setInterface:[NetworkInfo WiFiIPAddress]];
    
    NSError *error;
    if ([httpServer start:&error]) {
        NSLog(@"已启动: %@:%hu", [NetworkInfo WiFiIPAddress], httpServer.port);
        return YES;
    }
    else {
        NSLog(@"%s_%@", __FUNCTION__, error);
        return NO;
    }
}

- (void)stop; {
    [httpServer stop];
}

@end
