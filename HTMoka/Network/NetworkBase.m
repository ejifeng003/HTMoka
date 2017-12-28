//
//  NetworkBase.m
//  BasePro
//
//  Created by liuny on 16/4/19.
//  Copyright © 2016年 szjn. All rights reserved.
//

#import "NetworkBase.h"
#import "NSDictionary+SetNullWithStr.h"
#import "YYCache.h"
#import "QSHCache.h"


@implementation NetworkBase

- (void)uploadMostImageWithURLString:(NSString *)URLString
                          parameters:(id)parameters
                         uploadDatas:(NSArray *)uploadDatas
                          uploadName:(NSString *)uploadName
                             success:(NetworkSuccessBlock)success
                             failure:(NetworkFailBlock)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    NSLog(@"url str is %@  %@ %ld  ==%@",URLString,parameters,uploadDatas.count,uploadName);

    for (int i=0; i<uploadDatas.count; i++) {
        [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
            
            NSString *imageName = [NSString stringWithFormat:@"%@[%i]", uploadName, i];
            NSData *imageData = UIImageJPEGRepresentation(uploadDatas[i],0.1);
            
            [formData appendPartWithFileData:imageData name:uploadName fileName:imageName mimeType:@"image/png"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            MyLog(@"---上传图片成功--");
            MyLog(@"responseObject is %@",responseObject);
            if (success) {
                success(responseObject[@"Data"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MyLog(@"---上传图片失败 ======%@--",error);
            
            if (failure) {
                failure(error);
            }
        }];
        
    }
}

//上传单张图片
-(void)networkUploadImageWithUrl:(NSString *)urlStr
                           image:(NSArray *)imageArr
                   imageParamKey:(NSString *)imageKey
                          params:(NSDictionary *)params
                         success:(NetworkSuccessBlock)success
                            fail:(NetworkFailBlock)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i< imageArr.count; i++) {
            NSData *imgData;
            //= imageArr[i];
            NSLog(@"当前的图片的data %@",imgData);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
            
        [formData appendPartWithFileData:imgData name:imageKey fileName:@"image.jpg" mimeType:imageFileName];
        }
    MyLog(@"---请求完毕--");
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"---上传图片成功--");
        [self networkSuccess:responseObject success:success fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"--上传图片失败--");
        fail(@"网络异常");
    }];
}
//-(NSDictionary *)packParam:(NSDictionary *)params{
//    NSMutableDictionary *newParam = [[NSMutableDictionary alloc] init];
//    NSDate *date = [NSDate date];
//    NSString *dateString = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [newParam setJsonValue:dateString key:@"Datetime"];
//    NSString *token = [ProjectManager sharedProjectManager].token;
//    [newParam setJsonValue:token key:@"Token"];
//    NSString *liv = [ProjectManager sharedProjectManager].loginUser.liv;
//    if(liv.length > 0){
//        [newParam setJsonValue:liv key:@"LIV"];
//    }
//    //加密最里面一层的Params
//    if(params){
//        NSString *paramsJson = [params JSONString];
//        MyLog(@"==[jsonStr:%@]==",paramsJson);
//        NSString *base64Json = [paramsJson base64];
//        [newParam setJsonValue:base64Json key:@"Params"];
//    }
//    //加密外面一层的param
//    NSString *finalParamJson = [newParam JSONString];
//    MyLog(@"===[finalStr:%@]===",finalParamJson);
//    return [NSDictionary dictionaryWithObject:[finalParamJson base64] forKey:@"param"];
//}

//Post
-(void)networkPostWithUrl:(NSString *)urlStr
                   params:(NSDictionary *)params
                  success:(NetworkSuccessBlock)success
                     fail:(NetworkFailBlock)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置相应内容类型
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    //请求超时 1分钟
    manager.requestSerializer.timeoutInterval = 60 ;
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        MyLog(@"response is %@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"====error[%@]====",error);
        fail(@"网络异常");
        [SPSVProgressHUD showErrorWithStatus:@"网络异常"];

    }];
}

//POST不进入networkSuccess
-(void)networkPostOutSuccessWithUrl:(NSString *)urlStr
                             params:(NSDictionary *)params
                            success:(NetworkSuccessBlock)success
                               fail:(NetworkFailBlock)fail{
    NSString * key = [NSString stringWithFormat:@"%@%@",urlStr,params==nil?@"{}":[params mj_JSONString]];
    
    MyLog(@"post  %@%@ ",urlStr,params);
        //[self packParam:params];
    if ([QSHCache qsh_ReadCacheforURL:key successBlock:success]) {
        [NetworkBase startRequestWithPost:params didUrl:urlStr didSuccess:success didFailed:fail];
        
    }else{
        if (fail) {
            fail(@"似乎已断开与互联网的连接。");
        }
    }
}
-(NSDictionary *)packParam:(NSDictionary *)params{
    NSMutableDictionary *newParam = [[NSMutableDictionary alloc] init];
    
     [newParam setJsonValue:@"0000" key:@"PurchaseCode"];
    NSLog(@"newparam is %@",newParam);
    
    return newParam;
}
//Get
-(void)networkGetWithUrl:(NSString *)urlStr
                  params:(NSDictionary *)params
                 success:(NetworkSuccessBlock)success
                    fail:(NetworkFailBlock)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置相应内容类型
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    //请求超时 1分钟
    manager.requestSerializer.timeoutInterval = 60 ;
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self networkSuccess:responseObject success:success fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"====error[%@]====",error);
        fail(@"网络异常");
        
    }];
}

//下载
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedName
               downloadSuccess:(NetworkSuccessBlock)success
               downloadFailure:(NetworkFailBlock)fail
                      progress:(void (^)(float progress))progress

{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:savedName];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        MyLog(@"File downloaded to: %@", filePath);
        if(error){
            fail(@"下载失败");
        }else{
            success(nil);
            
        }
    }];
    [downloadTask resume];
}

-(void)networkSuccess:(id)responseObject
              success:(NetworkSuccessBlock)success
                 fail:(NetworkFailBlock)fail{
    //子类继承重写
    
}

+(void)startRequestWithPost:(id)params
                     didUrl:(NSString*)urlStr
                 didSuccess:(NetworkSuccessBlock)success
                  didFailed:(NetworkFailBlock)fail{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //获取当前的解析的格式
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",  @"text/JavaScript",@"text/html",nil];    MyLog(@"param is %@ URL is %@",params,urlStr);
    //无网请求时间
    manager.requestSerializer.timeoutInterval = 60 ;
    
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = responseObject;
        NSString *statusStr = [NSString stringWithFormat:@"%@",result[@"Status"]];
        MyLog(@"response is %@  status is%@",responseObject,statusStr);

        if ([statusStr isEqualToString:@"1"]||[statusStr isEqualToString:@"2"]) {
            NSLog(@"请求成功");
                        if ([result[@"Data"] isKindOfClass:[NSNull class]]) {
                            success(nil);
                        }else{
//                            NSMutableArray *dataArr = [NSMutableArray new];
//                            [dataArr  addObject:result[@"Data"]];
            
                            NSString * key = [NSString stringWithFormat:@"%@%@",urlStr,params==nil?@"{}":[params mj_JSONString]];
                            [QSHCache qsh_saveDataCache:result[@"Data"] key:key];
                            success(result[@"Data"]);
                        }
        }else{
            MyLog(@"没有你要的数据");
            success(result[@"Msg"] );

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"====error[%@]====",error);
        fail(@"网络异常");
        [SPSVProgressHUD showErrorWithStatus:@"网络异常"];

    }];
}

@end
