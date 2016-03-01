//
//  ESFileListViewController.h
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESFileListViewController : UIViewController

/**
 *  默认 ESFileListFilterTypeAll
 */
@property (assign, nonatomic) NSInteger filterType;

- (instancetype)init;
- (instancetype)initWithDirectoryPath:(NSString *)directoryPath;

@end
