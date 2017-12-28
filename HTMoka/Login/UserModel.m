//
//  UserModel.m
//  HTMuseum
//
//  Created by SZHuaTo on 17/5/9.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "UserModel.h"

#define SPUserInfmation @"UserInfmationKey"
@implementation UserModel

/** 保存 */
-(BOOL)saveUserLoginModel{
    //保存用户的数据保存用户 
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    if (data) {
        
        NSUserDefaults * defa = [NSUserDefaults standardUserDefaults];
        
        [defa setObject:data forKey:SPUserInfmation];
        
        return [defa synchronize];
    }
    return NO;
}
/** 删除 */
-(BOOL)delUserLoginModel{
    
    //删除用户的数据
    [[NSUserDefaults  standardUserDefaults] removeObjectForKey:SPUserInfmation];
    
    return [[NSUserDefaults standardUserDefaults]synchronize];
    
}
/** 获取 */
+(UserModel*)getUserLoginModel{
    
    NSData * user = [[NSUserDefaults standardUserDefaults] objectForKey:SPUserInfmation];
    
    if (user) {
        //获取用户的数据
        UserModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:user];
        
        return model;
    }
    return nil;
}


@end
