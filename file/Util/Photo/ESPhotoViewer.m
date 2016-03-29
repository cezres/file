//
//  ESPhotoViewer.m
//  file
//
//  Created by 翟泉 on 16/3/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESPhotoViewer.h"
#import "ESPhotoItem.h"

@interface ESPhotoViewer ()
<UIScrollViewDelegate>
{
    
}

@property (assign, nonatomic) NSInteger scrollIndex;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger count;

@property (strong, nonatomic) NSArray<ESPhotoItem *> *items;

@end

@implementation ESPhotoViewer

- (instancetype)init; {
    if ([super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame; {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubView];
    }
    return self;
}

- (void)dealloc; {
    NSLog(@"%s", __FUNCTION__);
}

- (void)showForWindow; {
//    [UIApplication sharedApplication]
}

- (void)didMoveToSuperview; {
    [super didMoveToSuperview];
    
    
}

- (void)layoutSubviews; {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_scrollView.frame, self.bounds)) {
        NSLog(@"%s Height:%lf", __FUNCTION__, self.frame.size.height);
        
        _scrollView.frame = self.bounds;
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * (_count < 3 ? _count : 3), self.frame.size.height);
        for (int i=0; i<3; i++) {
            _items[i].frame = CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        }
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*self.scrollIndex, 0) animated:NO];
    }
}

- (void)setCount:(NSInteger)count; {
    _count = count;
    __weak typeof(self) weakself = self;
    [_items enumerateObjectsUsingBlock:^(ESPhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.count) {
            [weakself.scrollView addSubview:obj];
        }
        else {
            [obj removeFromSuperview];
        }
    }];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (count < 3 ? count : 3),
                                             self.scrollView.frame.size.height);
    
}


- (void)reloadData; {
    __weak typeof(self) weakself = self;
    
    self.count = [self.imageUrls count];
    if ([self.imageUrls count] <= 0) {
        return;
    }
    else if ([self.imageUrls count] < 3) {
        [self.imageUrls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakself.items[idx] loadImageWithURL:obj];
        }];
    }
    else {
        if (self.currentIndex == 0) {
            [self.items enumerateObjectsUsingBlock:^(ESPhotoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj loadImageWithURL:weakself.imageUrls[idx]];
            }];
            _scrollIndex = 0;
        }
        else if (self.currentIndex == self.imageUrls.count-1) {
            [_items[0] loadImageWithURL:self.imageUrls[self.currentIndex-2]];
            [_items[1] loadImageWithURL:self.imageUrls[self.currentIndex-1]];
            [_items[2] loadImageWithURL:self.imageUrls[self.currentIndex]];
            _scrollIndex = 2;
        }
        else {
            [_items[0] loadImageWithURL:self.imageUrls[self.currentIndex-1]];
            [_items[1] loadImageWithURL:self.imageUrls[self.currentIndex]];
            [_items[2] loadImageWithURL:self.imageUrls[self.currentIndex+1]];
            _scrollIndex = 1;
        }
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*self.currentIndex, 0) animated:NO];
    }
    
}


#pragma mark - 滚动
- (void)setScrollIndex:(NSInteger)scrollIndex; {
    if (scrollIndex == _scrollIndex) {
        return;
    }
    else if (self.count < 3) {  // 数量小于3
        self.currentIndex = scrollIndex;
        _scrollIndex = scrollIndex;
    }
    else if (scrollIndex > _scrollIndex) {
        // next
        self.currentIndex += (scrollIndex - _scrollIndex);
        _scrollIndex = scrollIndex;
        
        if (self.currentIndex == self.count-1) {
//            return;
        }
        else if (self.currentIndex == 1) {
//            return;
        }
        else {
            // 调整视图
            [_items[0] loadImageWithURL:self.imageUrls[self.currentIndex-1]];
            [_items[1] loadImageWithURL:self.imageUrls[self.currentIndex]];
            [_items[2] loadImageWithURL:self.imageUrls[self.currentIndex+1]];
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*1, 0) animated:NO];
            _scrollIndex = 1;
        }
    }
    else {
        // last
        self.currentIndex += (scrollIndex - _scrollIndex);
        _scrollIndex = scrollIndex;
        
        if (self.currentIndex == 0) {
//            return;
        }
        else if (self.currentIndex == self.count - 2) {
//            return;
        }
        else {
            // 调整视图
            [_items[0] loadImageWithURL:self.imageUrls[self.currentIndex-1]];
            [_items[1] loadImageWithURL:self.imageUrls[self.currentIndex]];
            [_items[2] loadImageWithURL:self.imageUrls[self.currentIndex+1]];
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*1, 0) animated:NO];
            _scrollIndex = 1;
        }
    }
    
    NSLog(@"%ld/%ld", self.currentIndex+1, self.count);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    self.scrollIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;;
}


#pragma mark - InitSubView
- (void)initSubView; {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor orangeColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    NSMutableArray<ESPhotoItem *> *mutableArray = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i=0; i<3; i++) {
        ESPhotoItem *item = [[ESPhotoItem alloc] init];
//        item.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        item.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        item.tag = i;
        [_scrollView addSubview:item];
        [mutableArray addObject:item];
    }
    
    _items = [NSArray arrayWithArray:mutableArray];
}

@end
