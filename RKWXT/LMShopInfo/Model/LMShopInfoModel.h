//
//  LMShopInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMShopInfoModelDelegate;

@interface LMShopInfoModel : NSObject
@property (nonatomic,assign) id<LMShopInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *shopInfoArr;
@property (nonatomic,strong) NSArray *allGoodsArr;
@property (nonatomic,strong) NSArray *comGoodsArr;

-(void)loadLMShopInfoData:(NSInteger)sshop_id;
@end

@protocol LMShopInfoModelDelegate <NSObject>
-(void)loadLMShopinfoDataSucceed;
-(void)loadLMShopinfoDataFailed:(NSString*)errormsg;

@end
