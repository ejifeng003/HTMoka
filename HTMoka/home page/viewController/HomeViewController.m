//
//  HomeViewController.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/27.
//  Copyright © 2017年 深圳华图测控. All rights reserved.

#import "HomeViewController.h"
#import "JournalViewController.h"
#import "ProjectSearchVC.h"
#import "CollectViewController.h"
#import "SignViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *journalBtn;//日志
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;//项目列表
@property (weak, nonatomic) IBOutlet UIButton *SignBtn;//签到
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;//签收

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
        
    [self initWithUI];
}

-(void)initWithUI
{
    _journalBtn.layer.cornerRadius = 5;
    _SignBtn.layer.cornerRadius = 5;
    _collectBtn.layer.cornerRadius = 5;
    
    _typeBtn.layer.cornerRadius = 4;
    _typeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _typeBtn.layer.borderWidth = 1;
    
    //    [self.view addSubview:_journalBtn];
//    [self.view addSubview:_typeBtn];
}
- (IBAction)journalClick:(id)sender {
    //日志点击事件
    JournalViewController *vc = [[JournalViewController alloc]init];

    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)signClick:(id)sender {
    //签到
    SignViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignViewController"] ;
    vc.probjectName = LLBUserInfo.probjectName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)collectClick:(id)sender {
    //签收点击事件
    CollectViewController *vc = [[CollectViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)proobjctClick:(id)sender {
    //项目列表
    ProjectSearchVC *vc = [[ProjectSearchVC alloc]init];
    [vc didSelectedItem:^(NSString *item,NSString *probjectid) {
        LLBUserInfo.probjectName = item;
        LLBUserInfo.probjectID = probjectid;
        [_typeBtn setTitle:item forState:UIControlStateNormal];
    }];
     [self.navigationController pushViewController:vc animated:YES];
}

@end
