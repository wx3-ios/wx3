//
//  LimitBuyMakeOrderModel.h
//  RKWXT
//
//  Created by SHB on 15/11/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol LimitBuyMakeOrderModelDelegate;

@interface LimitBuyMakeOrderModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LimitBuyMakeOrderModelDelegate>delegate;
@property (nonatomic,strong) NSString *orderID;

-(void)submitOneOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString*)remark withProID:(NSInteger)proID withCarriage:(CGFloat)postage withGoodsList:(NSArray*)goodsList;
@end

@protocol LimitBuyMakeOrderModelDelegate <NSObject>
-(void)limitBuyMakeOrderSucceed;
-(void)limitBuyMakeOrderFailed:(NSString*)errorMsg;

@end
