//
//  ESHTTPConnection.m
//  file
//
//  Created by 翟泉 on 16/3/1.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"
#import "HTTPLogging.h"
#import "MultipartFormDataParser.h"
#import "MultipartMessageHeaderField.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPFileResponse.h"

#import "ESFileManager.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_VERBOSE; // | HTTP_LOG_FLAG_TRACE;


NSUInteger filesize = 0;


@interface ESHTTPConnection ()
{
//    MultipartFormDataParser*        parser;
//    NSFileHandle*					storeFile;
//    
//    NSMutableArray*					uploadedFiles;
}
@end

@implementation ESHTTPConnection


- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path; {
    
    return [super supportsMethod:method atPath:path];
}
- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path; {
    
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path; {
    if ([path isEqualToString:@"/favicon.ico"]) {
        return [super httpResponseForMethod:method URI:path];
    }
    
    if ([method isEqualToString:@"GET"] && [path isEqualToString:@"/img/dir"]) {
        UIImage *image = [UIImage imageNamed:@"Directory"];
        NSData *data = UIImagePNGRepresentation(image);
        return [[HTTPDataResponse alloc] initWithData:data];
    }
    
    // https://codeload.github.com/square/SocketRocket/zip/master
    // http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fwww.oschina.net%2Fuploads%2Fspace%2F2013%2F0607%2F172837_VK0b_257703.png&thumburl=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D181191284%2C706963040%26fm%3D15%26gp%3D0.jpg
    
    /**
     *  图片
     */
    if ([method isEqualToString:@"GET"] && [path rangeOfString:@"/img?"].length > 0) {
        
    }
    
    
    NSString *flag = [path substringToIndex:1];
    
    if ([method isEqualToString:@"GET"]/* && [path isEqualToString:@"/"]*/ && [flag isEqualToString:@"/"]) {
        NSData *response = nil;
        
        NSMutableString *html = [NSMutableString string];
        
        
        [html appendString:@"<html>\n<head>\n<meta content=\"text/html; charset=UTF-8\" http-equiv=\"content-type\">"];
        [html appendString:@"</head><body>"];
        
        
        [html appendString:@"<br><ul>\n"];
        NSArray<ESFileModel *> *files = [[ESFileManager sharedInstance] contentsOfDirectoryPath:path];
        [files enumerateObjectsUsingBlock:^(ESFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == ESFileTypeDirectory) {
                [html appendFormat:@"<li><img src=\"/img/dir\" /><a href=\"%@/\">%@</a></li>\n", obj.name, obj.name];
            }
            else if (obj.type == ESFileTypePhoto) {
                [html appendFormat:@"<li><img src=\"img?path=111\" /><a href=\"%@/\">%@</a></li>\n", obj.name, obj.name];
            }
            else {
                [html appendFormat:@"<li><a href=\"%@\">%@</a></li>\n", obj.name, obj.name];
            }
        }];
        [html appendString:@"</ul>\n"];
        
        NSString *str = @"<form action=\"upload.html\" method=\"post\" enctype=\"multipart/form-data\" accept-charset=\"utf-8\">\n\
        <input type=\"file\" name=\"upload2\"><br/>\n\
        <input type=\"submit\" value=\"Submit\">\n\
        </form>\n";
        
        [html appendString:str];
        
        [html appendString:@"</body></html>"];
        
        response = [/*@"<html><body>Sorry - Try Again<body></html>"*/html dataUsingEncoding:NSUTF8StringEncoding];
        return [[HTTPDataResponse alloc] initWithData:response];
    }
    
    
    return [super httpResponseForMethod:method URI:path];
}


@end
