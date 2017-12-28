//
//  GoodsDetailModel.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/12/4.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailModel : NSObject
@property (nonatomic,copy) NSString *SlaveCode;//从表编码
@property (nonatomic,copy) NSString *PurchaseCode;//订单信息表编码
@property (nonatomic,copy) NSString *CommodityCode;//物品编码
@property (nonatomic,copy) NSString *Num;//订单数
@property (nonatomic,copy) NSString *UnitPrice;//单价
@property (nonatomic,copy) NSString *PurchaseLocation;//采购地点
@property (nonatomic,copy) NSString *Unit;//单位
@property (nonatomic,copy) NSString *NumberStorage;//已入库数
@property (nonatomic,copy) NSString *State;//状态
@property (nonatomic,copy) NSString *CommodityName;//物品名称


@end
