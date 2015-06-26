//
//  MakeOrderModel.h
//  RKWXT
//
//  Created by SHB on 15/6/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol MakeOrderDelegate;

@interface MakeOrderModel : T_HPSubBaseModel
@property (nonatomic,assign) id<MakeOrderDelegate>delegate;

-(void)submitOneOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(CGFloat)packet withRemark:(NSString*)remark withGoodsList:(NSArray*)goodsList;
@end

@protocol MakeOrderDelegate <NSObject>
-(void)makeOrderSucceed;
-(void)makeOrderFailed:(NSString*)errorMsg;

@end
//order_total_money：订单总金额
//total_fee：实际支付总金额
//red_packet：使用红包金额
//remark：备注
//goods:{  #json字符串
//    [
//     goods_id:#商品ID
//     goods_name:商品名称
//     goods_img: 商品图片 去掉图片前缀 添加时填写
//     goods_stock_id:#商品库存ID
//     sales_price:销售单价
//     sales_number:销售数量
//     ]
//    
//    [
//     goods_id:#商品ID
//     goods_name:商品名称
//     goods_img: 商品图片 去掉图片前缀 添加时填写
//     goods_stock_id:#商品库存ID
//     sales_price:销售单价
//     sales_number:销售数量
//     ]
//}
