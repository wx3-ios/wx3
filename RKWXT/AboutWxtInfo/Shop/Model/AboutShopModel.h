//
//  AboutShopModel.h
//  RKWXT
//
//  Created by SHB on 15/7/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol AboutShopInfoDelegate;;

@interface AboutShopModel : T_HPSubBaseModel
@property (nonatomic,readonly) NSArray *shopInfoArr;
@property (nonatomic,assign) id<AboutShopInfoDelegate>delegate;

-(void)loadShopInfo;
@end

@protocol AboutShopInfoDelegate <NSObject>
-(void)loadShopInfoSucceed;
-(void)loadShopInfoFailed:(NSString*)errorMsg;

@end
