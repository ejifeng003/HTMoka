//
//  NetworkUrl.h
//  BasePro
//
//  Created by liuny on 16/4/19.
//  Copyright © 2016年 szjn. All rights reserved.
//

/*
 *此处存放项目中接口请求url
 */

#ifndef NetworkUrl_h
#define NetworkUrl_h

//#if DEBUG
//#define BaseUrl @"http://huato2008.eicp.net:8020"//线下测试
//#else
//#define BaseUrl @"http://huato.net:8019"//线上生产

//#endif

#define BaseUrl [NSString stringWithFormat:@"%@",LLBUserInfo.IP]//头域名地址
#define fPinUrl(url) [NSString stringWithFormat:@"%@/%@",BaseUrl,url]

//线上生产   线下测试
#define kUrlLoginByAccount   fPinUrl(@"api/UserHandle/UserLogin")//登录
#define kUrlConstructionLog  fPinUrl(@"api/BasicInformation/ConstructionLog")//日志
#define kUrlGoodsSign  fPinUrl(@"api/BasicInformation/PurchaseOrderSignIn")//货物签收
#define kUrlGoodsTable  fPinUrl(@"api/BasicInformation/GetPurchaseOrderInformation")//货物列表
#define kUrlGoodsDetailTable  fPinUrl(@"api/BasicInformation/GetPurchaseOrderInformationTable")//货物列表详情
#define kUrlSignSubmit  fPinUrl(@"api/BasicInformation/SignInInformation")//签到
#define kUrlUploading  fPinUrl(@"api/BasicInformation/UploadingImgByte")//文件上传
#define kUrlGetProject  fPinUrl(@"api/BasicInformation/GetProjectData")//项目列表

#endif /* NetworkUrl_h */

