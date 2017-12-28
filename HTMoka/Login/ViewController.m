//
//  ViewController.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/27.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//


#import "ViewController.h"
#import "HomeTarController.h"
#import "UserModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *rememberPWBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.LoginBtn.layer.cornerRadius = 4;
    LLBUserInfo.IP= portUrl;
    self.rememberPWBtn.selected = LLBUserInfo.isSavePassword;
    self.userTextFeild.text = LLBUserInfo.userName;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    
    //判断是否储存密码
    if (LLBUserInfo.isSavePassword) {
        self.passwordTextField.text = LLBUserInfo.passWord;
    }
}
//登录界面的回调    
- (IBAction)loginClick:(id)sender {
    if ([NSString isBlankString:self.userTextFeild.text] | [NSString isBlankString:self.passwordTextField.text]) {
        //[MBProgressHUD showSuccess:@"请输入账号或密码"];
        return;
    }

    //存入沙盒
    [LLBUserInfo setUserName:self.userTextFeild.text];
    [LLBUserInfo setPassWord:self.passwordTextField.text];
    [self LoginNetWork];

//    HomeTarController *tarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeTarController"] ;
//    [UIApplication sharedApplication].keyWindow.rootViewController = tarVC;
    
}

-(void)LoginNetWork
{
    [SPSVProgressHUD showWithStatus:@"正在登录..."];
    [[NetworkManager sharedNetworkManager] requestLoginByAccount:self.userTextFeild.text password:self.passwordTextField.text success:^(id result) {
        [SPSVProgressHUD dismiss];
        
        MyLog(@"data is %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"请求正确");
            [SPSVProgressHUD showSuccessWithStatus:@"登录成功"];
            NSArray * modelArr = [UserModel mj_objectArrayWithKeyValuesArray:result];
            
            if (modelArr.count>0) {
                UserModel * user = modelArr[0] ;
                [user saveUserLoginModel];
            }
            
            HomeTarController *tarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeTarController"] ;
            [UIApplication sharedApplication].keyWindow.rootViewController = tarVC;
            
        }
        
    } fail:^(NSString *errorMsg) {
        //显示网络异常
        [SPSVProgressHUD dismiss];
        
    }];
    
}
- (IBAction)rememberClick:(id)sender {
    if (self.rememberPWBtn.selected == YES) {
        self.rememberPWBtn.selected = NO;
        [LLBUserInfo setIsSavePassword:NO];
    }else{
        self.rememberPWBtn.selected = YES;
        [LLBUserInfo setIsSavePassword:YES];
    }
     //LLBUserInfo.isSavePassword = self.rememberPWBtn.selected;

}

@end
