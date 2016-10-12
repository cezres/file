//
//  VideoPlayer.h
//  VideoPlayer
//
//  Created by 翟泉 on 2016/9/24.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for VideoPlayer.
FOUNDATION_EXPORT double VideoPlayerVersionNumber;

//! Project version string for VideoPlayer.
FOUNDATION_EXPORT const unsigned char VideoPlayerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <VideoPlayer/PublicHeader.h>

/// 视频播放器
@interface VideoPlayer : UIViewController


+ (instancetype)playVideoWithURL:(NSURL *)URL title:(NSString *)title inController:(UIViewController *)controller;

@end



