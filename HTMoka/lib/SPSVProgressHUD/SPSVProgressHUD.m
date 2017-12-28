//
//  SPSVProgressHUD.m
//  SmartPurifieriOS
//
//  Created by Wind on 2016/11/14.
//  Copyright © 2016年 SmartPurifieriOS. All rights reserved.
//

#import "SPSVProgressHUD.h"

/**
 *  判断超时
 */
static BOOL isShowHUD = NO;

/**
 *  默认超时时间
 */
static NSTimeInterval minimumDismissTime = 10;

@implementation SPSVProgressHUD

+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)timeInterval
{
    [SVProgressHUD setMinimumDismissTimeInterval:timeInterval];
}

+(void)SVProgressHUDStyleDark
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

+(void)SVProgressHUDStyleLight
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

+(void)SVProgressHUDMaskTypeClear
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}
+(void)SVProgressHUDMaskTypeBlack
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+(void)show
{
    [SPSVProgressHUD SVProgressHUDStyleDark];
    [SPSVProgressHUD SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}
+ (void)showWithStatus:(NSString*)status
{
    [SPSVProgressHUD SVProgressHUDStyleDark];
    [SPSVProgressHUD SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:status];
}

+(void) showWithStatus:(NSString *)status withTimeout:(NSInteger)timeout
{
    isShowHUD = YES;
    [SPSVProgressHUD SVProgressHUDStyleDark];
    [SPSVProgressHUD SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:status];
    
    if (timeout < 0) {
        timeout = minimumDismissTime;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isShowHUD) {
            isShowHUD = NO;
            [SPSVProgressHUD showErrorWithStatus:@"操作超时"];
        }
    });
}

+ (void)showSuccessWithStatus:(NSString*)status
{
    isShowHUD = NO;
    [self SVProgressHUDStyleDark];
    [self setMinimumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString*)status
{
    isShowHUD = NO;
    [self SVProgressHUDStyleDark];
    [self setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)showWithStatusWithDarkStyle:(NSString*)status {

        [self showWithStatus:status];
        [self SVProgressHUDMaskTypeClear];
        [self setMinimumDismissTimeInterval:1];
}
+ (void)showSuccessWithStatusWithDarkStyle:(NSString*)status {
        [self SVProgressHUDMaskTypeClear];
        [self setMinimumDismissTimeInterval:1];
        [self showSuccessWithStatus:status];
}
#pragma mark- show Error 显示设定的秒数会自动消失
+ (void)showErrorWithStatusWithDarkStyle:(NSString*)status{

        [self showErrorWithStatus:status];
        [self SVProgressHUDMaskTypeClear];
        [self setMinimumDismissTimeInterval:1];
}


+(void)dismiss
{
    isShowHUD = NO;
    [SVProgressHUD dismiss];
}
+ (void)dismissWithDelay:(NSTimeInterval)delay
{
    isShowHUD = NO;
    [SVProgressHUD dismissWithDelay:delay];
}

@end
