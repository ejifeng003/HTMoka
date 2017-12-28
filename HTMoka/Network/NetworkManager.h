//
//  NetworkManager.h
//  BasePro
//
//  Created by liuny on 16/4/19.
//  Copyright © 2016年 szjn. All rights reserved.
//

/*
 * 项目接口
 */

#import <Foundation/Foundation.h>
#import "NetworkBase.h"
#import "Singleton.h"

@interface NetworkManager : NetworkBase
singleton_interface(NetworkManager)

#pragma mark - 账号密码登录
-(void)requestLoginByAccount:(NSString *)account
                    password:(NSString *)password
                     success:(NetworkSuccessBlock)success
                        fail:(NetworkFailBlock)fail;

#pragma mark - 主页
-(void)requestHomePage:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;

#pragma mark -日志提交
-(void)requestConstructionLog:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;

#pragma mark -货物提交
-(void)requestlGoodsSign:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;

#pragma mark - 货物列表
-(void)requestGoodsTable:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;

#pragma mark - 货物详情
-(void)requestGoodsDetailTable:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;

#pragma mark - 签到
-(void)requestSignSubmit:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;

#pragma mark - 文件上传
-(void)requestUploading:(NSDictionary *)param  image:(NSArray*)imageDataArr imageParamKey:(NSString*)imageKey success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;

#pragma mark - 项目列表
-(void)requestGetProject:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail;
@end
