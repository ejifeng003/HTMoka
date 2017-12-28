//
//  CollectHeaderView.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/30.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectHeaderView : UIView
@property  (nonatomic,copy)void(^SearchBlock)(UIImage *uploadImage);

+(CollectHeaderView*)creatViewWithTargetView:(UIView*)targetView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;

@end
