//
//  ESDataTransferViewController.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESDataTransferViewController.h"

@interface ESDataTransferViewController ()

@end

@implementation ESDataTransferViewController

- (instancetype)init; {
    if (self = [super init]) {
        self.title = @"数据传输";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
    
}



- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
    
    
//    static int isFullScreen = 3; //   1 == 全屏  3 == 竖屏
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

//
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
