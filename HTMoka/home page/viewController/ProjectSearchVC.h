//
//  ProjectSearchVC.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/30.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedItem)(NSString *item,NSString *probjectid);
@interface ProjectSearchVC : UITableViewController

@property (strong, nonatomic) SelectedItem block;

- (void)didSelectedItem:(SelectedItem)block;

@end
