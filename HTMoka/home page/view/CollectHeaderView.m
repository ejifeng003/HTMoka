//
//  CollectHeaderView.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/30.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "CollectHeaderView.h"

@interface
CollectHeaderView()
{
    UITextView *textview;
}

@end

@implementation CollectHeaderView

+(CollectHeaderView*)creatViewWithTargetView:(UIView*)targetView
{
    
    CollectHeaderView *view = [[LLBMainBundle loadNibNamed:@"CollectHeaderView" owner:nil options:0]firstObject];
    view.typeBtn.layer.cornerRadius = 4;
    view.typeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    view.typeBtn.layer.borderWidth = 1;
    view.collectImage.layer.masksToBounds = YES;
    view.collectImage.layer.cornerRadius = 7;
    
    return view;
}
- (IBAction)typeClick:(id)sender {
    //签收订单点击事件
    
}

- (IBAction)uploadClick:(id)sender {
    //上传签单
    if(self.SearchBlock){
        self.SearchBlock(_collectImage.image);
    }
}

@end
