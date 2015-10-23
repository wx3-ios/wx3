//
//  ClassifyGoodsModel.h
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol ClassifyGoodsModelDelegate;

@interface ClassifyGoodsModel : T_HPSubBaseModel
@property (nonatomic,assign) id<ClassifyGoodsModelDelegate>delegate;
@property (nonatomic,strong) NSArray *goodsListArr;

-(void)loadClassifyGoodsListData:(NSInteger)catID;
@end

@protocol ClassifyGoodsModelDelegate <NSObject>
-(void)loadClassifyGoodsListDataSucceed;
-(void)loadClassifyGoodsListDataFailed:(NSString*)errorMsg;

@end
