//
//  ESNetworkInfo.h
//  file
//
//  Created by 翟泉 on 16/5/20.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESNetworkInfo : NSObject

/**
 *  IP地址
 *
 *  @return <#return value description#>
 */
+ (NSString *)IPAddress;
/**
 *  Wifi名称
 *
 *  @return <#return value description#>
 */
+ (NSString *)WifiName;
/**
 *  Wifi局域网IP地址
 *
 *  @return <#return value description#>
 */
+ (NSString *)WiFiIPAddress;

@end
