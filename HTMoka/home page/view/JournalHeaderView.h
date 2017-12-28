//
//  JournalHeaderView.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/30.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property  (nonatomic,copy)void(^SearchBlock)(NSString *typeStr);

+(JournalHeaderView*)creatViewWithTargetView:(UIView*)targetView;

@end
