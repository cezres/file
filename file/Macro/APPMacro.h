//
//  APPMacro.h
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#ifndef APPMacro_h
#define APPMacro_h

// 设备逻辑分辨率
#define SSize [UIScreen mainScreen].bounds.size


#define F10     [UIFont fontWithName:@"ArialMT" size:10]
#define F12     [UIFont fontWithName:@"ArialMT" size:12]
#define F13     [UIFont fontWithName:@"ArialMT" size:13]
#define F14     [UIFont fontWithName:@"ArialMT" size:14]
#define F16     [UIFont fontWithName:@"ArialMT" size:16]
#define Font(fontSize) [UIFont fontWithName:@"ArialMT" size:fontSize]



#define ColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorRGB(r,g,b) ColorRGBA(r,g,b,1.0)




#endif /* APPMacro_h */
