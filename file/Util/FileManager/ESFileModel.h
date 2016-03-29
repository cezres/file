//
//  ESFileModel.h
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  文件类型
 */
typedef NS_ENUM(NSInteger, ESFileType) {
    /**
     *  目录
     */
    ESFileTypeDirectory = 1,
    /**
     *  照片
     */
    ESFileTypePhoto,
    /**
     *  视频
     */
    ESFileTypeVideo,
    /**
     *  音频
     */
    ESFileTypeAudio,
    /**
     *  未知
     */
    ESFileTypeUnknown,
};

/**
 *  文件数据模型
 */
@interface ESFileModel : NSObject

/**
 *  文件路径
 */
@property (strong, nonatomic) NSString *path;
///**
// *  相对路径
// */
//@property (strong, nonatomic) NSString *relativePath;
/**
 *  文件名称
 */
@property (strong, nonatomic) NSString *name;
/**
 *  文件类型
 */
@property (assign, nonatomic) ESFileType type;
#pragma mark - Attributes
/**
 *  创建日期
 */
@property (strong, nonatomic) NSDate *creationDate;
/**
 *  文件大小
 */
@property (assign, nonatomic) NSUInteger size;
/**
 *  是否隐藏
 */
@property (assign, nonatomic, getter=isHidden) BOOL hidden;

@property (assign, nonatomic) NSInteger fileNumber;


#pragma mark - Init
/**
 *  根据文件路径初始化对象
 *
 *  @param path 文件路径
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFilePath:(NSString *)path;

/**
 *  根据相对路径初始化
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithRelativePath:(NSString *)path;

@end

















