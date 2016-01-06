//
//  RCHeader.h
//  RCDownSheet
//
//  Created by razeen on 12/31/15.
//  Copyright © 2015 razeen. All rights reserved.
//

#ifndef RCHeader_h
#define RCHeader_h


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define kScreenWIDTH ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define kSCALE(value) (value * (kScreenWIDTH/320.0f))
//  颜色相关
#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue,alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#endif

#define RGBAA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define APP [UIApplication sharedApplication]
#define topHeight ((APP.statusBarHidden || !(IS_IOS7())) ? 0 : 20)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)

//iOS版本
#define CURRENT_VERSION [[[UIDevice currentDevice] systemVersion] integerValue]
#define IOS7 7
#define IOS8 8
#define IOS9 9
#define IS_IOS7() ((CURRENT_VERSION>=IOS7) ? YES : NO)
#define IS_IOS8() ((CURRENT_VERSION>=IOS8) ? YES : NO)
#define IS_IOS9() ((CURRENT_VERSION>=IOS9) ? YES : NO)


#endif /* RCHeader_h */
