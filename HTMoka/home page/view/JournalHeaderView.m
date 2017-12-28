//
//  JournalHeaderView.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/30.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import "JournalHeaderView.h"

@implementation JournalHeaderView

+(JournalHeaderView*)creatViewWithTargetView:(UIView*)targetView
{
    JournalHeaderView *view = [[LLBMainBundle loadNibNamed:@"JournalHeaderView" owner:nil options:0]firstObject];
    view.typeBtn.layer.cornerRadius = 4;
    view.typeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    view.typeBtn.layer.borderWidth = 1;
    
    return view;
}

- (IBAction)typeClick:(id)sender {
    //类型的点击事件
    if(self.SearchBlock){
        self.SearchBlock(nil);
    }
}
@end
