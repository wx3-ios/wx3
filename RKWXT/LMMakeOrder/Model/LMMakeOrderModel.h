//
//  LMMakeOrderModel.h
//  RKWXT
//
//  Created by SHB on 15/12/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMMakeOrderDelegate;

@interface LMMakeOrderModel : NSObject
@property (nonatomic,assign) id<LMMakeOrderDelegate>delegate;
@property (nonatomic,strong) NSString *lmOrderID;

-(void)submitOneOrderWithAllMoney:(CGFloat)allMoney withTotalMoney:(CGFloat)totalMoney withRedPacket:(NSInteger)packet withRemark:(NSString *)remark withProID:(NSInteger)proID withCarriage:(CGFloat)postage withGoodsList:(NSArray *)goodsList shopID:(NSInteger)shopID;
@end

@protocol LMMakeOrderDelegate <NSObject>
-(void)lmMakeOrderSucceed;
-(void)lmMakeOrderFailed:(NSString*)errorMsg;

@end
