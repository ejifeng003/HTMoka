//
//  NSString+XZ.m
//  xzz
//
//  Created by Jason on 11/7/15.
//  Copyright © 2015 hk. All rights reserved.
//

#import "NSString+ljt.h"
#define  Token_suffix @"111domain_api"
@implementation NSString (ljt)

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+ (NSString*)handelNull:(NSString*)string
{

    if ([NSString isBlankString:string]) {
       string = @"";
    }
    
    return string;
}
- (long long)filesSize
{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:self error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            totalSize += [fullSubpath filesSize]; // 递归子文件
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:self error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}


+ (NSString*)StringWIthInteger:(NSInteger)number
{
    NSString *Str = [NSString stringWithFormat:@"%ld",number];
    return Str;
}

+(int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}

+(NSString *)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"mm:HH dd-MM-yyyy"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间大");
        return @"1";
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间小");
        return @"2";
    }
    //NSLog(@"两者时间是同一个时间");
    return @"3";
    
}

//-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
//{
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
//    UIFont *font = [UIFont systemFontOfSize:20];
//    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,4)];
//    [attrString addAttribute:NSFontAttributeName value:[UIFont fontwith:12] range:NSMakeRange(4,needText.length-4)];
//    
//    return attrString;
//}
//- (BOOL)isPureInt:(NSString*)string{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    int val;
//    return[scan scanInt:&val] && [scan isAtEnd];
//}
@end
