//
//  ProjectSearchModel.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/12/6.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectSearchModel : NSObject
@property (nonatomic,copy) NSString *ProjectCode;
@property (nonatomic,copy) NSString *ActualTime;//项目的时间
@property (nonatomic,copy) NSString *ContractAmount;//项目的金额
@property (nonatomic,copy) NSString *ProjectCCustomerNameode;
@property (nonatomic,copy) NSString *CustomerPhone;//项目的手机号
@property (nonatomic,copy) NSString *ProjectName;//项目的名称
@property (nonatomic,copy) NSString *ProjectPrincipal;
@property (nonatomic,copy) NSString *ProjectStaDate;
@property (nonatomic,copy) NSString *ScheduledTime;
@property (nonatomic,copy) NSString *State;

@end
