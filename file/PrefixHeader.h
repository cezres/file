//
//  PrefixHeader.h
//  file
//
//  Created by 翟泉 on 16/3/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#import <UIKit/UIKit.h>

#import "file-Swift.h"


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define iOS7GE [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//我喜欢的蓝色
#define YiBlue [UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f]
//灰色
#define YiGray [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]
#define YiTextGray [UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f]
#define YiRed [UIColor colorWithRed:0.93 green:0.41 blue:0.36 alpha:1]

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define YKClientId @"bf5803ceb7daf89c"



#import "APPMacro.h"
#import "Extension/Extension.h"

#import "Masonry.h"
//#import <Masonry/Masonry.h>
//#import <fi>

#import <KVOController/FBKVOController.h>

/**
 *  侧滑菜单
 */
#import "RESideMenu.h"


#endif /* PrefixHeader_h */
