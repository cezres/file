//
//  UIAlertView+Block.m
//  buyer
//
//  Created by 云之彼端 on 15/11/17.
//  Copyright © 2015年 云之彼端. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

@implementation UIAlertView (Block)

- (void)setClickedButtonBlock:(void (^)(void))clickedButtonBlock; {
    objc_setAssociatedObject(self, @selector(clickedButtonBlock), clickedButtonBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(void))clickedButtonBlock; {
    return objc_getAssociatedObject(self, @selector(clickedButtonBlock));
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles ClickedButtonBlock:(void (^)(void))clickedButtonBlock; {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    alertView.delegate = alertView;
    alertView.clickedButtonBlock = clickedButtonBlock;
    [alertView show];
}

+ (void)showAlertWithMessage:(NSString *)message confirmBlock:(void (^)(void))confirmBlock; {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = alertView;
    alertView.clickedButtonBlock = confirmBlock;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
    if (self.clickedButtonBlock != NULL) {
        if (buttonIndex == 1) {
            self.clickedButtonBlock();
        }
    }
}


@end












