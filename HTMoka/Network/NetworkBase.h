//
//  NetworkBase.h
//  BasePro
//
//  Created by liuny on 16/4/19.
//  Copyright © 2016年 szjn. All rights reserved.
//

/*
 *AFNetwork网络请求的基本方法
 */

#import <Foundation/Foundation.h>

typedef void (^NetworkSuccessBlock) (NSDictionary *result);
typedef void (^NetworkFailBlock) (NSString *errorMsg);

@interface NetworkBase : NSObject
#pragma mark - 多张图片上传
- (void)uploadMostImageWithURLString:(NSString *)URLString
                          parameters:(id)parameters
                         uploadDatas:(NSArray *)uploadDatas
                          uploadName:(NSString *)uploadName
                             success:(NetworkSuccessBlock)success
                             failure:(NetworkFailBlock)failure;

#pragma mark - 单张图片上传
-(void)networkUploadImageWithUrl:(NSString *)urlStr
                           image:(NSArray *)imageArr
                   imageParamKey:(NSString *)imageKey
                          params:(NSDictionary *)params
                         success:(NetworkSuccessBlock)success
                            fail:(NetworkFailBlock)fail;


#pragma mark - POST
-(void)networkPostWithUrl:(NSString *)urlStr
                   params:(NSDictionary *)params
                  success:(NetworkSuccessBlock)success
                     fail:(NetworkFailBlock)fail;
//POST不进入networkSuccess
-(void)networkPostOutSuccessWithUrl:(NSString *)urlStr
                             params:(NSDictionary *)params
                            success:(NetworkSuccessBlock)success
                               fail:(NetworkFailBlock)fail;

#pragma mark - GET
-(void)networkGetWithUrl:(NSString *)urlStr
                  params:(NSDictionary *)params
                 success:(NetworkSuccessBlock)success
                    fail:(NetworkFailBlock)fail;

#pragma mark - 成功处理
-(void)networkSuccess:(id)responseObject
              success:(NetworkSuccessBlock)success
                 fail:(NetworkFailBlock)fail;


@end
