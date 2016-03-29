//
//  ESSettingViewController.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESSettingViewController.h"
#import "ESPhotoViewer.h"
#import "UpYun.h"

@interface ESSettingViewController ()
{
    UpYun *uy;
}
@end

@implementation ESSettingViewController

- (instancetype)init; {
    if (self = [super init]) {
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"d2c-pic";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"5LiKYAotpBipKnLJhV2IC3U2VG4=";
    
    
    uy = [[UpYun alloc] init];
    
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"response body %@", responseData);
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"error %@", message);
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        //        [_pv setProgress:percent];
    };
    uy.uploadMethod = UPMutUPload;
    
    
    UIImage * im = [UIImage imageWithContentsOfFile:@"/Users/cezr/Documents/fe4b3bcdcadf4501b06053b0ed3a5760.jpg"];
    [uy uploadFile:im saveKey:@"/app/c/16/03/11/A70239000070D538239A3551BD8C46B4"/*[self getSaveKeyWith:@"jpg"]*/];
    
    
//    ESPhotoViewer *photoViewer = [[ESPhotoViewer alloc] init];
//    photoViewer.frame = CGRectMake(20, 200, SSize.width-40, 100);
//    [self.view addSubview:photoViewer];
//    
//    
//    
//    NSArray *imagePaths = @[@"37006382.png",
//                            @"38947047.png",
//                            @"39060333.png",
//                            @"40737139_p0.png",
//                            @"40737139_p1.png",
//                            @"43493473.png",
//                            @"43771191.png",
//                            @"44725235_p0.png",
//                            @"44757303_p0.png",
//                            @"44759103_p0.png",
//                            @"44988844_p0.png",
//                            @"45232684_p0.png",
//                            @"45454055_p0.png",
//                            @"45638133_p0.png",];
//    
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:imagePaths.count];
//    for (NSString *path in imagePaths) {
//        [mutableArray addObject:[[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"/Users/cezr/Documents/Bilibili/安静向12首图包曲包/%@", path]]];
//    }
//    imagePaths = [NSArray arrayWithArray:mutableArray];
//    
//    
//    photoViewer.imageUrls = imagePaths;
//    [photoViewer reloadData];
    
    /*
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
    
    self.view.center = center;
    
    
    CGAffineTransform transform;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        transform = CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        transform =  CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        transform =  CGAffineTransformMakeRotation(-M_PI);
    } else {
        transform =  CGAffineTransformIdentity;
    }
    
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:YES];
    
    
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    self.view.transform = transform;
    
    [UIView commitAnimations];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
