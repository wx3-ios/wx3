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
@property (nonatomic,strong) NSString *orderID;

-(void)submitOneOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString*)remark withProID:(NSInteger)proID withCarriage:(CGFloat)postage withGoodsList:(NSArray*)goodsList;
@end

@protocol MakeOrderDelegate <NSObject>
-(void)makeOrderSucceed;
-(void)makeOrderFailed:(NSString*)errorMsg;

@end
