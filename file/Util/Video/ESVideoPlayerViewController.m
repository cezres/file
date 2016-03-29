//
//  ESVideoPlayerViewController.m
//  file
//
//  Created by 翟泉 on 16/2/29.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESVideoPlayerViewController.h"



@interface ESVideoPlayerViewController ()

@end

@implementation ESVideoPlayerViewController

- (instancetype)initWithFilePath:(NSString *)path; {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
//    static int isFullScreen = 3; //   1 == 全屏  3 == 竖屏
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        
//        [invocation setSelector:selector];
//        
//        [invocation setTarget:[UIDevice currentDevice]];
//        
//        
//        NSLog(@"-%d-",isFullScreen);
//        
//        [invocation setArgument:&isFullScreen atIndex:2];
//        
//        [invocation invoke];
//        
//    }
}

- (void)viewWillDisappear:(BOOL)animated; {
    [super viewWillDisappear:animated];
    
//    static int isFullScreen = 1; //   1 == 全屏  3 == 竖屏
//    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        
//        [invocation setSelector:selector];
//        
//        [invocation setTarget:[UIDevice currentDevice]];
//        
//        
//        NSLog(@"-%d-",isFullScreen);
//        
//        [invocation setArgument:&isFullScreen atIndex:2];
//        
//        [invocation invoke];
//        
//    }
}

@end




@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end