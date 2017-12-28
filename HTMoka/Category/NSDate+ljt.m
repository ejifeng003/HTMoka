//
//  NSDate+ljt.m
//  LengLianBao
//
//  Created by SZHuaTo on 17/3/9.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "NSDate+ljt.h"

@implementation NSDate (ljt)
+ (NSString*)getTimeStrWithFormatter:(NSString*)formatterStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = formatterStr;
    //
    NSString *TimeStr = [formatter stringFromDate:date];
    
    return TimeStr;
}

+ (CGFloat)getTodayZeroTimeinterval
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSString *formatterStr = @"YYYY-MM-dd HH:mm:ss";
    formatter.dateFormat = formatterStr;
    NSString *str =[NSString stringWithFormat:@"%@ 00:00:00",[NSDate getTimeStrWithFormatter:@"YYYY-MM-dd"]];
    NSDate *Newdate = [formatter dateFromString:str];
    
    NSNumber *number = [NSNumber numberWithFloat:[Newdate timeIntervalSince1970]];
    
    return [number floatValue];
}

//
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
    
}

+ (NSString*)getTimeStrWithDate:(NSDate*)date FormatterStr:(NSString*)formatterStr
{
    NSDateFormatter *formatter  = [NSDateFormatter new];
    formatter.dateFormat = formatterStr;
    NSString *TimeStr = [formatter stringFromDate:date];
    return TimeStr;
    
    
}
+ (CGFloat)getTimeintavalWithDay:(NSInteger)day
{
    
    CGFloat TodayZeroTimeInterval = [[NSDate date] timeIntervalSince1970];
    CGFloat TimeSpace = day * 24 *60 *60 ;
    
    return TodayZeroTimeInterval - TimeSpace;
}
+ (NSDate*)getDateWithStr:(NSString *)Datestr andFormateter:(NSString*)Formatterstr
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:Formatterstr];
    
    return [formatter dateFromString:Datestr];
}

@end
