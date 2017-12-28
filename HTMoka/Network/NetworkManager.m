//
//  NetworkManager.m
//  BasePro
//
//  Created by liuny on 16/4/19.
//  Copyright © 2016年 szjn. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkUrl.h"


@implementation NetworkManager
singleton_implementation(NetworkManager)


//版本检测(AppStore)
//-(void)requestAppStoreVersionCheck:(NSString *)url
//                           success:(NetworkSuccessBlock)success
//                              fail:(NetworkFailBlock)fail{
//    [self networkPostOutSuccessWithUrl:url params:nil success:success fail:fail];
//}

#pragma mark - 账号密码登录
-(void)requestLoginByAccount:(NSString *)account password:(NSString *)password success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    //储存数据
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setJsonValue:account key:@"LoginName"];
    [params setJsonValue:password key:@"LoginPass"];
    //加密
    //        NSString *passwordMd5 = [password md5].uppercaseString;
    //    [params setJsonValue:passwordMd5 key:@"pwd"];
    
    //请求数据
    [self networkPostOutSuccessWithUrl:kUrlLoginByAccount params:params success:success fail:fail];
    
}

#pragma mark - 主页
-(void)requestHomePage:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    [self networkPostOutSuccessWithUrl:kUrlConstructionLog params:param success:success fail:fail];
    
}

#pragma mark - 日志提交
-(void)requestConstructionLog:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    
    [self networkPostOutSuccessWithUrl:kUrlConstructionLog params:param success:success fail:fail];
    
}
#pragma mark - 货物提交
-(void)requestlGoodsSign:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    
    [self networkPostOutSuccessWithUrl:kUrlGoodsSign params:param success:success fail:fail];
    
}

#pragma mark - 货物列表
-(void)requestGoodsTable:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    
    [self networkPostOutSuccessWithUrl:kUrlGoodsTable params:param success:success fail:fail];
}

#pragma mark - 货物详情
-(void)requestGoodsDetailTable:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    
    [self networkPostOutSuccessWithUrl:kUrlGoodsDetailTable params:param success:success fail:fail];
}

#pragma mark - 签到
-(void)requestSignSubmit:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    
    [self networkPostOutSuccessWithUrl:kUrlSignSubmit params:param success:success fail:fail];
}

#pragma mark - 文件上传
-(void)requestUploading:(NSDictionary *)param  image:(NSArray*)imageDataArr imageParamKey:(NSString*)imageKey success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    [self uploadMostImageWithURLString:kUrlUploading parameters:nil uploadDatas:imageDataArr uploadName:imageKey success:success failure:fail];
   // [self networkUploadImageWithUrl:kUrlUploading image:imageDataArr imageParamKey:imageKey params:nil success:success fail:fail];
}

#pragma mark - 项目列表
-(void)requestGetProject:(NSDictionary *)param success:(NetworkSuccessBlock)success fail:(NetworkFailBlock)fail{
    [self networkPostOutSuccessWithUrl:kUrlGetProject params:param success:success fail:fail];
}



@end

