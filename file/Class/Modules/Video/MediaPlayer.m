//
//  MediaPlayer.m
//  IJKMediaPlayer
//
//  Created by cezr on 16/7/17.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "MediaPlayer.h"
//#import "IJKMediaPlayer.h"
#import <IJKMediaPlayer/IJKMediaPlayer.h>
#import "MediaPlayerControl.h"
#import "Masonry.h"

@interface MediaPlayer ()
{
    NSURL *_url;
    MediaPlayerControl *_mediaControl;
    
    NSString *_title;
}

@property(strong, nonatomic) id<IJKMediaPlayback> player;

@end

@implementation MediaPlayer


+ (instancetype)playerWithURL:(NSURL *)url title:(NSString *)title inViewController:(UIViewController *)controller; {
    MediaPlayer *player = [[MediaPlayer alloc] initWithURL:url title:title];
    [controller presentViewController:player animated:YES completion:NULL];
    return player;
}

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title; {
    if (self = [super init]) {
        _url = [url copy];
        _title = title;
    }
    return self;
}

- (void)dealloc; {
    NSLog(@"%s", __FUNCTION__);
}

- (UIStatusBarStyle)preferredStatusBarStyle; {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad; {
    [super viewDidLoad];
    
    NSParameterAssert(_url);
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
//    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:_url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
//    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    
    
    _mediaControl = [[MediaPlayerControl alloc] initWithPlayer:self.player viewController:self];
    _mediaControl.title = _title;
    [self.view addSubview:_mediaControl];
    
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.view.bounds.size.width > self.view.bounds.size.height) {
            make.top.offset = 0;
        }
        else {
            make.top.offset = 20;
        }
        make.bottom.offset = 0;
        make.left.offset = 0;
        make.right.offset = 0;
    }];
    
    [_mediaControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.player.view);
    }];
    
}


- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
    [self.player prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
}

- (void)viewWillLayoutSubviews; {
    [self.player.view mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.view.bounds.size.width > self.view.bounds.size.height) {
            make.top.offset = 0;
        }
        else {
            make.top.offset = 20;
        }
    }];
    [super viewWillLayoutSubviews];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}



@end
