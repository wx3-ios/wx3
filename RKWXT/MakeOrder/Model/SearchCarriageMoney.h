//
//  SearchCarriageMoney.h
//  RKWXT
//
//  Created by SHB on 15/11/6.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchCarriageMoneyDelegate;

@interface SearchCarriageMoney : NSObject
@property (nonatomic,assign) id<SearchCarriageMoneyDelegate>delegate;
@property (nonatomic,assign) CGFloat carriageMoney;
-(void)searchCarriageMoneyWithProvinceID:(NSInteger)provinceID goodsInfo:(NSString*)goodsInfo shopID:(NSInteger)shopID;
@end

@protocol SearchCarriageMoneyDelegate <NSObject>
-(void)searchCarriageMoneySucceed;
-(void)searchCarriageMoneyFailed:(NSString*)errorMsg;

@end
