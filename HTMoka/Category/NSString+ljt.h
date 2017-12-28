//
//  NSString+XZ.h
//  xzz
//
//  Created by Jason on 11/7/15.
//  Copyright © 2015 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ljt)
/**
 *  判断字符串是否为空或空格
 *
 *
 *
 *  @return BOOL
 */
+ (BOOL)isBlankString:(NSString *)string;
//- (BOOL)isPureInt:(NSString*)string;

- (long long)filesSize;

//转换NSInteger为字符串
+ (NSString*)StringWIthInteger:(NSInteger)number;
//将字符串为NSNull时转成@""
+ (NSString*)handelNull:(NSString*)string;

//返回状态字符
+(int)convertToInt:(NSString*)strtemp;

+(NSString *)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end
