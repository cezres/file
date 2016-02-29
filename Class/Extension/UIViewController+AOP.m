//
//  UIViewController+AOP.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "UIViewController+AOP.h"
#import "NSObject+SwizzleMethod.h"

@implementation UIViewController (AOP)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(viewDidLoad) swizzledSelector:@selector(aop_viewDidLoad)];
    });
    
}

- (void)aop_viewDidLoad {
    NSString *className = [[self class] description];
    if ([className rangeOfString:@"ES"].length > 0) {
        self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [self.view addSubview:[[UIView alloc] initWithFrame:CGRectZero]];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }
//    if ([self isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navigation = (UINavigationController *)self;
//        navigation.navigationBar.tintColor = [UIColor whiteColor];
//        navigation.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//        navigation.navigationBar.barTintColor = [UIColor blackColor];
//    }
    [self aop_viewDidLoad];
}


@end