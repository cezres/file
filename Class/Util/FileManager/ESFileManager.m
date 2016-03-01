//
//  ESFileManager.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESFileManager.h"



@implementation ESFileManager

+ (ESFileManager *)sharedInstance; {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSArray<ESFileModel *> *)contentsOfDirectoryPath:(NSString *)directoryPath; {
    NSMutableArray<ESFileModel *> *contents = [NSMutableArray array];
    [self traverseDirectory:[self.DocumentsPath stringByAppendingString:directoryPath] callback:^(ESFileModel *file) {
        [contents addObject:file];
    }];
    
    
//    NSString *match = @"imagexyz-999.png";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type == %d", ESFileTypeDirectory];
    NSArray *Directory = [contents filteredArrayUsingPredicate:predicate];
//    NSLog(@"%@", Directory);
    
    NSMutableArray *files = [NSMutableArray arrayWithCapacity:contents.count];
    [files addObjectsFromArray:Directory];
    
    
    for (ESFileModel *file in contents) {
        if (file.type != ESFileTypeDirectory) {
            [files addObject:file];
        }
    }
    
    
    return files;
}

- (void)removeFile:(ESFileModel *)file; {
    [[NSFileManager defaultManager] removeItemAtPath:file.path error:NULL];
}

- (void)createDirectoryWithPath:(NSString *)path; {
    [self.fileManager createDirectoryAtPath:[self.DocumentsPath stringByAppendingString:path] withIntermediateDirectories:YES attributes:NULL error:NULL];
}

#pragma mark - Private
/**
 *  遍历目录
 *
 *  @param directoryPath  目录路径
 *  @param isSubDirectory 是否遍历子目录
 *  @param callback       回调
 */
- (void)traverseDirectory:(NSString *)directoryPath isSubDirectory:(BOOL)isSubDirectory callback:(void (^)(ESFileModel *file))callback; {
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
    for (NSString *fileName in fileNames) {
        // 文件路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", directoryPath, fileName];
        ESFileModel *file = [[ESFileModel alloc] initWithFilePath:filePath];
        callback(file);
        // 如果遍历子目录，并且当前文件为目录
        if (isSubDirectory && file.type == ESFileTypeDirectory) {
            [self traverseDirectory:filePath isSubDirectory:isSubDirectory callback:callback];
        }
    }
}
/**
 *  遍历目录，不遍历子级目录
 *
 *  @param directoryPath <#directoryPath description#>
 *  @param callback      <#callback description#>
 */
- (void)traverseDirectory:(NSString *)directoryPath callback:(void (^)(ESFileModel *file))callback; {
    [self traverseDirectory:directoryPath isSubDirectory:NO callback:callback];
}

#pragma mark - Lazy
- (NSString *)DocumentsPath; {
    if (_DocumentsPath == NULL) {
#if TARGET_IPHONE_SIMULATOR
        _DocumentsPath = @"/Users/cezr/Documents";
#else
        _DocumentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
#endif
    }
    return _DocumentsPath;
}
- (NSString *)CachesPath; {
    if (_CachesPath == NULL) {
#if TARGET_IPHONE_SIMULATOR
        _CachesPath = @"/Users/cezr/Documents/APP_FILE_CACHES";
#else
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _CachesPath = [paths objectAtIndex:0];
#endif
        
    }
    return _CachesPath;
}
- (NSFileManager *)fileManager; {
    if (_fileManager == NULL) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

@end
