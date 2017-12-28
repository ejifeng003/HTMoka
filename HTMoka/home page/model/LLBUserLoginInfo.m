//
//  LLBUserLoginInfo.m
//  LengLianBao
//
//  Created by SZHuaTo on 17/2/28.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "LLBUserLoginInfo.h"
#define kIP @"userInfo_IP"
#define kUserID @"userInfo_UserID"
#define kPort @"userInfo_port"
#define kPassword @"userInfo_password"
#define kIsSavePassword @"userInfo_isSavePassword"
#define kIsAutomaticLogin @"userINfo_isAutomaticLogin"
#define kIsLogOnAutomatic @"userINfo_isLogOnAutomatic"
#define kIPprobjectName @"probjectName"
#define klUsername @"user_Name"



@implementation LLBUserLoginInfo
singleton_implementation(LLBUserLoginInfo)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.IP = [LLBUserDefaults objectForKey:kIP];
        
        self.userID = [LLBUserDefaults objectForKey:kUserID];
        self.passWord = [LLBUserDefaults objectForKey:kPassword];
        self.userName = [LLBUserDefaults objectForKey:klUsername ];
        self.isSavePassword = [LLBUserDefaults boolForKey:kIsSavePassword];
        self.isSavePassword = [LLBUserDefaults boolForKey:kIsSavePassword];
        self.probjectName = [LLBUserDefaults objectForKey:kIPprobjectName];
        
    }
    return self;
}



- (void)setIP:(NSString *)IP
{
    _IP = IP;
    [LLBUserDefaults setObject:IP forKey:kIP];
     [LLBUserDefaults synchronize];
    
}


//- (void)setUserName:(NSString *)userName
//{
//    self.userName =userName;
//    [LLBUserDefaults setObject:userName forKey:klUsername];
//    [LLBUserDefaults synchronize];
//
//}

- (void)setUserName:(NSString *)userName
{
    _userName =userName;
    [LLBUserDefaults setObject:userName forKey:klUsername];
    [LLBUserDefaults synchronize];
    
}


- (void)setUserID:(NSString *)userID
{
    //userID
    _userID =userID;
    [LLBUserDefaults setObject:userID forKey:kUserID];
    [LLBUserDefaults synchronize];
    
}

-(void)setW_Rate:(NSString *)W_Rate
{
    _W_Rate =W_Rate;
    [LLBUserDefaults setObject:W_Rate forKey:@"W_Rate"];
    [LLBUserDefaults synchronize];
 
}

-(void)setH_Rate:(NSString *)H_Rate
{
    _H_Rate =H_Rate;
    [LLBUserDefaults setObject:H_Rate forKey:@"H_Rate"];
    [LLBUserDefaults synchronize];
    
}
-(void)setPassWord:(NSString *)passWord
{
    //保存密码
    _passWord = passWord;
    if(self.isSavePassword){
    [LLBUserDefaults setObject:passWord forKey:kPassword];
     [LLBUserDefaults synchronize];
    }else{
        [LLBUserDefaults setObject:@"" forKey:kPassword];
        [LLBUserDefaults synchronize];
    }
}

-(void)setIsSavePassword:(BOOL)isSavePassword
{
    _isSavePassword = isSavePassword;
    [LLBUserDefaults setBool:isSavePassword forKey:kIsSavePassword];
    [LLBUserDefaults synchronize];
    
}


@end
