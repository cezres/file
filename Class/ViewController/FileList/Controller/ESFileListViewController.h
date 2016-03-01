//
//  ESFileListViewController.h
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  文件列表状态
 */
typedef NS_ENUM(NSInteger, ESFileListState) {
    /**
     *  正常
     */
    ESFileListStateNormal,
    /**
     *  移动
     */
    ESFileListStateMove,
    /**
     *  拷贝
     */
    ESFileListStateCopy
};

@interface ESFileListViewController : UIViewController

@property (strong, nonatomic) NSString *directoryPath;

/**
 *  默认 ESFileListFilterTypeAll
 */
@property (assign, nonatomic) NSInteger filterType;


@property (assign, nonatomic) NSInteger state;

- (instancetype)init;
- (instancetype)initWithDirectoryPath:(NSString *)directoryPath;

@end
