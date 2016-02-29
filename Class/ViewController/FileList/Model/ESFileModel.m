//
//  ESFileModel.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESFileModel.h"

@implementation ESFileModel


- (instancetype)initWithFilePath:(NSString *)path; {
    if (self = [super init]) {
        _path = [path copy];
        _name = [_path lastPathComponent];
        
        
        BOOL isDirectory;
        [[NSFileManager defaultManager] fileExistsAtPath:_path isDirectory:&isDirectory];
        if (isDirectory) {
            _type = ESFileTypeDirectory;
        }
        else if ([_path.pathExtension isEqualToString:@"png"] ||
                 [_path.pathExtension isEqualToString:@"jpg"] ||
                 [_path.pathExtension isEqualToString:@"jpeg"]) {
            _type = ESFileTypePhoto;
        }
        else if ([_path.pathExtension isEqualToString:@"flv"] ||
                 [_path.pathExtension isEqualToString:@"mp4"]) {
            _type = ESFileTypeVideo;
        }
        else if ([_path.pathExtension isEqualToString:@"mp3"]) {
            _type = ESFileTypeAudio;
        }
        else {
            _type = ESFileTypeUnknown;
        }
        
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:_path error:NULL];
        _creationDate = [attributes objectForKey:@"NSFileCreationDate"];
        _size = [[attributes objectForKey:@"NSFileSize"] integerValue];
        _hidden = [[attributes objectForKey:@"NSFileExtensionHidden"] boolValue];
    }
    return self;
}

- (NSString *)description; {
    return [NSString stringWithFormat:@"名称:%@", _name];
}

@end
