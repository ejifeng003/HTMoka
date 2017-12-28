//
//  NSDate+ljt.h
//  LengLianBao
//
//  Created by SZHuaTo on 17/3/9.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ljt)
//按格式获取当前时间
+ (NSString*)getTimeStrWithFormatter:(NSString*)formatterStr;
+ (NSString*)getTimeStrWithDate:(NSDate*)date FormatterStr:(NSString*)formatterStr;
//获取某天时间戳
+ (CGFloat)getTimeintavalWithDay:(NSInteger)day;

+ (NSDate*)getDateWithStr:(NSString *)Datestr andFormateter:(NSString*)Formatterstr;
//获取当天凌晨时间戳
+ (CGFloat)getTodayZeroTimeinterval;

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end
