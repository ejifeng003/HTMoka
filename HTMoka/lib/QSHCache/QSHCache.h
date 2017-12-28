//
//  QSHCache.h
//
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 mac. All rights reserved.
//

//  此类方便YYCache的统一调用


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef void (^RequestSuccess)(id response);

@interface QSHCache : NSObject



/**
 缓存保存 解密后的

 @param data 缓存数据
 
 @param url url
 */
+ (void)qsh_saveDataCache:(id)data key:(NSString*)url;


/**
 读取缓存
 */
+ (BOOL)qsh_ReadCacheforURL:(NSString*)url successBlock:(RequestSuccess)success;

/**读取缓存文件的大小*/
+ (CGFloat)qsh_GetAllHttpCacheSize ;

/**是否缓存*/
+ (BOOL)qsh_IsCache:(NSString *)key ;

/**删除某个磁盘缓存文件*/
+ (void)qsh_RemoveChache:(NSString *)key ;

/**删除所有的磁盘换存文件*/
+ (void)qsh_RemoveAllCache ;



@end
