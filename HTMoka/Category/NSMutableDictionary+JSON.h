//
//  NSMutableDictionary+JSON.h
//  BasePro
//
//  Created by liuny on 15/10/12.
//  Copyright (c) 2015年 szjn. All rights reserved.
//
/*
 *主要用于网络请求，JSON解析空判断，以及小数位数的保留
 */


#import <Foundation/Foundation.h>

@interface NSMutableDictionary (JSON)
-(NSString *)getJsonValue:(NSString *)key;
-(void)setJsonValue:(NSString *)value key:(NSString *)key;
-(void)setJsonArr:(NSArray *)value key:(NSString *)key;
-(void)setJsonDic:(NSDictionary *)value key:(NSString *)key;

-(NSString *)JSONString;
@end
