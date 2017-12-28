//
//  LLBnavigationController.m
//  LengLianBao
//
//  Created by SZHuaTo on 17/2/28.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "LLBnavigationController.h"

@interface LLBnavigationController ()

@end

@implementation LLBnavigationController

+ (void)initialize
{
    // 1.设置导航栏主题
    
    [self setupNavBarTheme];
    // 2.设置导航栏按钮主题
    [self setupItemTheme];
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    // 1.获得bar对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 2.设置背景图片
    // 设置导航栏的渐变色为白色（iOS7中返回箭头的颜色变为这个颜色：白色）
    navBar.tintColor = [UIColor whiteColor];
    //    [navBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:UIBarMetricsDefault];
    //    [navBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    //    navBar.barStyle = UIStatusBarStyleDefault;
    //[navBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    UIImage *image = [self createImageWithColor:SPMainColor];
    
    [navBar setBackgroundImage:image
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    //    [navBar setBackgroundImage:image
    //                forBarPosition:UIBarPositionTopAttached
    //                    barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    
    //navBar.clipsToBounds = YES;
    // 3.设置文字样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    //    attrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    
    [navBar setTitleTextAttributes:attrs];
    
}

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for(UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


/**
 * 设置导航栏按钮主题
 */
+ (void)setupItemTheme
{
    // 1.获得appearance对象, 就能修改主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 2.设置背景
    /******普通状态******/
    // 按钮文字
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    // 设置文字颜色
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    // 去掉阴影
    //    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    // 设置文字字体
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    /******高亮状态******/
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionary];
    highTextAttrs.dictionary = textAttrs;
    // 设置文字颜色
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.200 alpha:1.000];
    [item setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    /******不可用状态******/
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs.dictionary = textAttrs;
    // 设置文字颜色
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.200 alpha:0.500];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果push的不是根控制器(不是栈底控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        // 左上角的返回
         viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        //[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];     // viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    self.view.backgroundColor = [UIColor whiteColor]; //解决push时右上角的黑条
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end


