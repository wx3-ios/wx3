//
//  LuckyGoodsModel.h
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

typedef enum{
    LuckyGoods_Type_Normal = 0,
    LuckyGoods_Type_Loading,
    LuckyGoods_Type_Refresh,
}LuckyGoods_Type;

@protocol LuckyGoodsModelDelegate;

@interface LuckyGoodsModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LuckyGoodsModelDelegate>delegate;
@property (nonatomic,strong) NSArray *luckyGoodsArr;
@property (nonatomic,assign) LuckyGoods_Type type;

-(void)loadLuckyGoodsListWith:(NSInteger)startItem with:(NSInteger)length;
@end

@protocol LuckyGoodsModelDelegate <NSObject>
-(void)loadLuckyGoodsSuceeed;
-(void)loadLuckyGoodsFailed:(NSString *)errorMsg;

@end
