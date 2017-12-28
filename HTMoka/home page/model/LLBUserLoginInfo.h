//
//  LLBUserLoginInfo.h
//  LengLianBao
//
//  Created by SZHuaTo on 17/2/28.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface LLBUserLoginInfo : NSObject
@property(nonatomic, strong)NSString *IP;
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *passWord;
@property(nonatomic,copy) NSString *W_Rate;
@property(nonatomic,copy) NSString *H_Rate;
@property(nonatomic,copy) NSString *probjectName;
@property(nonatomic,copy) NSString *probjectID;

@property(nonatomic,copy) NSString *userName;

@property(nonatomic, assign)BOOL    isSavePassword;//是否保存密码

singleton_interface(LLBUserLoginInfo);

@end
