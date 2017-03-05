//
//  PhotoMemoryCache.m
//  file
//
//  Created by 翟泉 on 2017/2/15.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

#import "PhotoMemoryCache.h"
#import <PINCache/PINCache.h>
#import <PINCache/PINOperationQueue.h>

@interface PhotoMemoryCache ()


@property (strong, nonatomic) PINMemoryCache *memoryCache;

@end

@implementation PhotoMemoryCache


+ (instancetype)sharedCache {
    static id cache;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        cache = [[self alloc] init];
    });
    
    return cache;
}

- (instancetype)init {
    if (self = [super init]) {
        PINOperationQueue *operationQueue = [[PINOperationQueue alloc] initWithMaxConcurrentOperations:10];
        _memoryCache = [[PINMemoryCache alloc] initWithOperationQueue:operationQueue];
        _memoryCache.costLimit = 40;
        _memoryCache.ageLimit = 60 * 60;
        _memoryCache.removeAllObjectsOnMemoryWarning = YES;
        _memoryCache.removeAllObjectsOnEnteringBackground = NO;
        [_memoryCache setDidReceiveMemoryWarningBlock:^(PINMemoryCache *cache) {
            [cache trimToCost:4];
        }];
    }
    return self;
}


- (BOOL)containsObjectForKey:(NSString *)key {
    return [_memoryCache containsObjectForKey:key];
}

- (__nullable id)objectForKey:(nullable NSString *)key {
    return [_memoryCache objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    return [_memoryCache setObject:object forKey:key];
}

- (void)removeAllObjects {
    [_memoryCache removeAllObjects];
}


@end
