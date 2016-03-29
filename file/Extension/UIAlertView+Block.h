//
//  UIAlertView+Block.h
//  buyer
//
//  Created by 云之彼端 on 15/11/17.
//  Copyright © 2015年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

@property(strong, nonatomic) void (^clickedButtonBlock)(void);

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles ClickedButtonBlock:(void (^)(void))clickedButtonBlock;

+ (void)showAlertWithMessage:(NSString *)message confirmBlock:(void (^)(void))confirmBlock;

@end
