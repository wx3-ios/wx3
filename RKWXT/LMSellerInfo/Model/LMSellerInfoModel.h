//
//  LMSellerInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMSellerInfoModelDelegate;

@interface LMSellerInfoModel : NSObject
@property (nonatomic,assign) id<LMSellerInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *sellerInfoArr;
@property (nonatomic,strong) NSArray *shopListArr;

-(void)loadLMSellerInfoData:(NSInteger)ssid;
@end

@protocol LMSellerInfoModelDelegate <NSObject>
-(void)loadLMSellerInfoDataSucceed;
-(void)loadLMSellerInfoDataFailed:(NSString*)errorMsg;

@end
