//
//  GoodsTableModel.h
//  HTMoka
//
//  Created by SZHuaTo on 2017/12/4.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsTableModel : NSObject
@property (nonatomic,copy) NSString *PurchaseCode;//编号
@property (nonatomic,copy) NSString *PurchaseTitle;//标题
@property (nonatomic,copy) NSString *SignInFileName;
@property (nonatomic,copy) NSString *SignInFileUrl;//图片地址

@end
