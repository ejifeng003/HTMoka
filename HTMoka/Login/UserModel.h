//
//  UserModel.h
//  HTMuseum
//
//  Created by SZHuaTo on 17/5/9.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : SPBaseModel
@property (nonatomic,copy) NSString *name;//用户名称
@property (nonatomic,copy) NSString *Idc;//用户id
@property (nonatomic,copy) NSString *passWord;//用户密码
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *Address;

/** 保存 */
-(BOOL)saveUserLoginModel;
/** 删除 */
-(BOOL)delUserLoginModel;
/** 获取 */
+(UserModel*)getUserLoginModel;

@end
