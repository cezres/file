//
//  ESPhotoItem.m
//  file
//
//  Created by 翟泉 on 16/3/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESPhotoItem.h"

@interface ESPhotoItem ()
{
    UIImageView *_imageView;
    NSLayoutConstraint *imageViewWidth;
    NSLayoutConstraint *imageViewHeight;
    
    CGRect lastBounds;
}
@end

@implementation ESPhotoItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init; {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
        
//        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc; {
    NSLog(@"%s", __FUNCTION__);
//    [self removeObserver:self forKeyPath:@"frame"];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context; {
//    if ([keyPath isEqualToString:@"frame"]) {
//        [self autoImageViewFrame];
//    }
//}

- (void)layoutSubviews; {
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.bounds, lastBounds)) {
        NSLog(@"%s Height:%lf", __FUNCTION__, self.frame.size.height);
        [self autoImageViewFrame];
        lastBounds = self.bounds;
    }
}

- (void)loadImageWithURL:(NSURL *)url; {
    if (self.placeholderImage) {
        _imageView.image = self.placeholderImage;
        [self autoImageViewFrame];
    }
    
    /*__block */UIImage *image;
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        image = [UIImage imageWithData:data];
    }
    
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        if (data) {
//            image = [UIImage imageWithData:data];
//        }
//    });
    if (image) {
        _imageView.image = image;
        [self autoImageViewFrame];
    }
}


- (void)autoImageViewFrame; {
    UIImage *image = _imageView.image;
    if (image) {
        CGFloat newHeight = self.frame.size.width * image.size.height / image.size.width;
        if (newHeight < self.frame.size.height) {
            _imageView.frame = CGRectMake(0, (self.frame.size.height-newHeight)/2, self.frame.size.width, newHeight);
        }
        else {
            CGFloat newWidth = self.frame.size.height * image.size.width / image.size.height;
            _imageView.frame = CGRectMake((self.frame.size.width-newWidth)/2, 0, newWidth, self.frame.size.height);
        }
    }
}


#pragma mark - InitSubView
- (void)initSubView; {
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
}

@end
