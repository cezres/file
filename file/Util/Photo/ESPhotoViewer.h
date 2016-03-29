//
//  ESPhotoViewer.h
//  file
//
//  Created by 翟泉 on 16/3/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESPhotoViewer : UIView

@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSArray<NSURL *> *imageUrls;

- (void)reloadData;

@end
