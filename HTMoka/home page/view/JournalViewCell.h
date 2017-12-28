//
//  JournalViewCell.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/28.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalViewCell : UITableViewCell
@property  (nonatomic,copy)void(^SearchBlock)(NSInteger imgType, NSArray *uploadImage);
@property  (nonatomic,copy)void(^textViewBlock)(NSString *textstr);

- (void)cellSection:(CGFloat)section;//获取当前的section

@property (nonatomic,retain) NSString *textStr;


@end
