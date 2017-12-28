//
//  HomeTarController.m
//  LengLianBao
//
//  Created by SZHuaTo on 17/2/27.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "HomeTarController.h"

@interface HomeTarController ()

@end

@implementation HomeTarController
+(void)initialize
{
   // [[UITabBar appearance] setBackgroundColor:SPMainColor];

    UITabBar *tabBar = [UITabBar appearance];
    //UITabBarItem *tabbarItem = [UITabBarItem appearance] ;
    tabBar.tintColor=[UIColor whiteColor];
   // UITabBarItem *tabbarItem = [UITabBarItem appearance];
    // ---定义未选中和选中文字颜色
   // [tabbarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]forState:UIControlStateNormal];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, TabbarHeight)];
    //backView.backgroundColor = [UIColor colorWithHexString:@"32afff" alpha:.7];

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *rightEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    rightEffectView.frame = backView.frame;
    [backView addSubview:rightEffectView];

    [tabBar insertSubview:backView atIndex:0];
    tabBar.opaque = YES;
    [tabBar setBackgroundImage:[UIImage new]];
    [tabBar setShadowImage:[UIImage new]];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}


@end
