//
//  NSMutableDictionary+JSON.m
//  BasePro
//
//  Created by liuny on 15/10/12.
//  Copyright (c) 2015年 szjn. All rights reserved.
//

#import "NSMutableDictionary+JSON.h"

@implementation NSMutableDictionary (JSON)
-(void)setJsonValue:(NSString *)value key:(NSString *)key{
    if(key != nil && key.length > 0){
        self[key] = value==nil?@"":value;
    }
}
-(void)setJsonArr:(NSArray *)value key:(NSString *)key{
    if(key != nil && key.length > 0){
        self[key] = value==nil?@"":value;
    }
    
}
-(void)setJsonDic:(NSDictionary *)value key:(NSString *)key
{
    if(key != nil && key.length > 0){
        self[key] = value==nil?@"":value;
    }
}
-(NSString *)getJsonValue:(NSString *)key{
    NSString *value = self[key];
    if(value == nil || [value isEqual:[NSNull null]]){
        value = @"";
    }else{
        value = [NSString stringWithFormat:@"%@",value];
        if([self isPureDouble:value]){
            NSArray *array = [value componentsSeparatedByString:@"."];
            //有小数
            if(array.count == 2)
            {
                double pointNum = [value doubleValue];
                value = [NSString stringWithFormat:@"%.2f",pointNum];
            }
        }
    }
    return value;
}

//判断是否为整形
-(BOOL)isPureInt:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为double
-(BOOL)isPureDouble:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

//判断是否为浮点型
-(BOOL)isPureFloat:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

-(NSString *)JSONString
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return @"";
}
@end
