//
//  DirectoryWatcher.h
//  file
//
//  Created by 翟泉 on 2017/2/24.
//  Copyright © 2017年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DirectoryWatcher;

@protocol DirectoryWatcherDelegate <NSObject>

- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher;

@end

@interface DirectoryWatcher : NSObject

+ (DirectoryWatcher *)watchFolderWithPath:(NSString *)watchPath delegate:(id<DirectoryWatcherDelegate>)watchDelegate;

- (void)invalidate;

@end
