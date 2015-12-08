//
//  WXShopUnionModel.h
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXShopUnionModelDelegate;

@interface WXShopUnionModel : NSObject
@property (nonatomic,assign) id<WXShopUnionModelDelegate>delegate;
@property (nonatomic,strong) NSArray *hotGoodsArr;  //热门商品列表
@property (nonatomic,strong) NSArray *hotShopArr;  //热门商家列表
@property (nonatomic,strong) NSArray *classifyShopArr; //商家行业分类
@property (nonatomic,strong) NSArray *activityArr; //活动列表

-(void)loadShopUnionData:(NSInteger)areaID;
@end

@protocol WXShopUnionModelDelegate <NSObject>
-(void)loadShopUnionDataSucceed;
-(void)loadShopUnionDataFailed:(NSString*)errorMsg;

@end
