//
//  FileHTTPConnection.m
//  file
//
//  Created by 翟泉 on 16/5/21.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "FileHTTPConnection.h"
#import "HTTPConnection.h"

#import "HTTPDataResponse.h"
#import "HTTPAsyncFileResponse.h"

@implementation FileHTTPConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path; {
    if ([method isEqualToString:@"GET"]) {
        
        if ([path isEqualToString:@"/favicon.ico"]) {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *path = [bundle pathForResource:@"favicon" ofType:@"ico"];
            NSData *data = [NSData dataWithContentsOfFile:path];
//            return [[HTTPAsyncFileResponse alloc] initWithFilePath:path forConnection:self];
            return [[HTTPDataResponse alloc] initWithData:data];
        }
    }
    else if ([method isEqualToString:@"POST"]) {
        
    }
    return [super httpResponseForMethod:method URI:path];
}

@end
