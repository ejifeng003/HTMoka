//
//  SPSVProgressHUD.h
//  SmartPurifieriOS
//
//  Created by Wind on 2016/11/14.
//  Copyright © 2016年 SmartPurifieriOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface SPSVProgressHUD : NSObject

#pragma mark- 设置用户交互type
+ (void)SVProgressHUDMaskTypeClear;
+ (void)SVProgressHUDMaskTypeBlack;

#pragma mark- show 一直显示
+ (void)show;
+ (void)showWithStatus:(NSString*)status;

+(void) showWithStatus:(NSString *)status withTimeout:(NSInteger)timeout;
#pragma mark- show success 显示设定的秒数会自动消失
+ (void)showSuccessWithStatus:(NSString*)status;
#pragma mark- show Error 显示设定的秒数会自动消失
+ (void)showErrorWithStatus:(NSString*)status;


#pragma mark- 手动消失
+ (void)dismiss;
+ (void)dismissWithDelay:(NSTimeInterval)delay;


+ (void)showWithStatusWithDarkStyle:(NSString*)status ;
+ (void)showSuccessWithStatusWithDarkStyle:(NSString*)status ;
#pragma mark- show Error 显示设定的秒数会自动消失
+ (void)showErrorWithStatusWithDarkStyle:(NSString*)status;



@end
