//
//  PhotoMemoryCache.h
//  file
//
//  Created by 翟泉 on 2017/2/15.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoMemoryCache : NSObject

+ (nonnull instancetype)sharedCache;


- (BOOL)containsObjectForKey:(nullable NSString *)key;

- (__nullable id)objectForKey:(nullable NSString *)key;

- (void)setObject:(nullable id)object forKey:(nullable NSString *)key;

- (void)removeAllObjects;

@end
