//
//  WBaseModel.m
//  MyApp
//
//  Created by Amale on 16/4/27.
//  Copyright © 2016年 Wind. All rights reserved.
//

#import "SPBaseModel.h"

@implementation SPBaseModel

MJCodingImplementation

//MJLogAllIvars
 - (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
         /*  [Example] change property id to productID
           8      *
           9      *  if([key isEqualToString:@"id"]) {
           10      *
           11      *      self.productID = value;
           12      *      return;
           13      *  }
           14      */
    
     }
- (void)setValue:(id)value forKey:(NSString *)key {
     if ([value isKindOfClass:[NSNull class]]) {
        
                 return;
             }
     [super setValue:value forKey:key];
     }

 - (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
         if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
                 if (self = [super init]) {
                     
                         [self setValuesForKeysWithDictionary:dictionary];
                     }
             }
     
         return self;
     }



-(id) mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{

    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null]) {
    
            return @"";
        }else if ([oldValue isKindOfClass:[NSString class]]&& ([oldValue length]<=0 || [oldValue isEqualToString:@"null"])){
            return @"";
        }
    }
    return oldValue;
}



@end
