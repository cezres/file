//
//  ESDataTransferViewController.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESDataTransferViewController.h"
#import "ESNetworkInfo.h"

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


- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
    
    NSLog(@"\n%@, %@, %@", [ESNetworkInfo WifiName], [ESNetworkInfo WiFiIPAddress], [ESNetworkInfo IPAddress]);
}
- (void)viewWillDisappear:(BOOL)animated; {
    [super viewWillDisappear:animated];
    
    
}


@end
