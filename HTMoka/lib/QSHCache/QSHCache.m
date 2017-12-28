//
//  QSHCache.m
//  
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "QSHCache.h"
#import "YYCache.h"
#import "MJExtension.h"
@interface QSHCache ()

@property (nonatomic, strong) YYCache *dataCache;

@end

@implementation QSHCache

+(instancetype)shareManger {
    
    static QSHCache * manger = nil ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manger = [[QSHCache alloc] init];
        
        
    });
    
    return manger ;
}

static NSString *const qshCache = @"qsh_Cache";


/**
 
 @param data 缓存数据
 @param url url
 */
+ (void)qsh_saveDataCache:(id)data key:(NSString*)key{

     [[QSHCache shareManger].dataCache setObject:data forKey:key];
    
   
}


/**
 读取缓存
 
 @param param url
 @param url url
 @param success 网络请求中的block
 @return yes 走下一步
 */
+ (BOOL)qsh_ReadCacheforURL:(NSString*)key successBlock:(RequestSuccess)success{
    
    id obj = nil;
    
    obj = (NSString *)[[QSHCache shareManger].dataCache objectForKey:key];
    
    AFNetworkReachabilityManager * manager  = [AFNetworkReachabilityManager sharedManager];
    BOOL isNetwork = manager.networkReachabilityStatus==AFNetworkReachabilityStatusUnknown?YES:manager.isReachable;
    
    if (!isNetwork&& obj) {
        success([obj mj_JSONObject]);
    }else{
        
    }
    
    return isNetwork;
}







+ (CGFloat)qsh_GetAllHttpCacheSize
{
    
    
    // 总大小
    unsigned long long diskCache = [[QSHCache shareManger].dataCache.diskCache totalCost];
    
    NSString *sizeText = nil;
    
    if (diskCache >= pow(10, 9)) {
        // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", diskCache / pow(10, 9)];
    } else if (diskCache >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", diskCache / pow(10, 6)];
    } else if (diskCache >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", diskCache / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", diskCache];
    }
    
    CGFloat cacheSize = diskCache;

    return cacheSize ;

}

+ (BOOL)qsh_IsCache:(NSString *)key {
    
    return [[QSHCache shareManger].dataCache containsObjectForKey:key];
}

+ (void)qsh_RemoveChache:(NSString *)key {
    
    [[QSHCache shareManger].dataCache removeObjectForKey:key withBlock:nil];
}

+ (void)qsh_RemoveAllCache {
    
    [[QSHCache shareManger].dataCache removeAllObjects];
}




-(YYCache *)dataCache{

    if (_dataCache == nil) {
        
        _dataCache =[YYCache cacheWithName:qshCache];
    }
    
    return _dataCache;
}



@end
