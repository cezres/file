//
//  ESFileManager.h
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESFileModel.h"

@interface ESFileManager : NSObject

@property (strong, nonatomic) NSFileManager *fileManager;

/**
 *  文档路径
 */
@property (strong, nonatomic) NSString *DocumentsPath;
/**
 *  缓存路径
 */
@property (strong, nonatomic) NSString *CachesPath;

/**
 *  @return 返回文件管理单例对象
 */
+ (ESFileManager *)sharedInstance;

/**
 *  获取指定目录下文件列表
 *
 *  @param directorys 目录路径
 *
 *  @return <#return value description#>
 */
- (NSArray<ESFileModel *> *)contentsOfDirectoryPath:(NSString *)directoryPath;

/**
 *  移除文件
 *
 *  @param file <#file description#>
 */
- (void)removeFile:(ESFileModel *)file;

/**
 *  新建文件夹
 *
 *  @param path 文件夹路径
 */
- (void)createDirectoryWithPath:(NSString *)path;



@end
