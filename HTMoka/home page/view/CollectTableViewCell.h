//
//  CollectTableViewCell.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/30.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *CommodityCodeLabel;//型号
@property (weak, nonatomic) IBOutlet UITextField *numTextField;//数量
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;//订单的数量
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//签收的数量

@end
