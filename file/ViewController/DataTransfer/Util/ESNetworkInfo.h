//
//  ESNetworkInfo.h
//  file
//
//  Created by 翟泉 on 16/3/1.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络信息
 */
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
