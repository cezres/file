//
//  ESTextFieldAlertView.h
//  buyer
//
//  Created by 翟泉 on 16/2/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESTextFieldAlertView : UIView

- (void)show;
- (void)hide;
+ (ESTextFieldAlertView *)show;

@property (copy, nonatomic) void (^confirmBlock)(NSString *text);


+ (void)showAlertWithTitle:(NSString *)title confirmBlock:(void (^)(NSString *text))confirmBlock;

@end
