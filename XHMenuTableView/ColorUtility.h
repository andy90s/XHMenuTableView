//
//  ColorUtility.h
//  微博个人主页
//
//  Created by zenglun on 16/5/5.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorUtility : NSObject

/**
 *  16进制颜色
 *
 *  @param stringToConvert 色值
 *
 *  @return color值
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
