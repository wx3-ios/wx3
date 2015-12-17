//
//  LMSellerListModel.h
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMSellerListModelDelegate;

@interface LMSellerListModel : NSObject
@property (nonatomic,assign) id<LMSellerListModelDelegate>delegate;
@property (nonatomic,strong) NSArray *sellerListArr;

-(void)loadAllSellerListData:(NSInteger)industryID;
@end

@protocol LMSellerListModelDelegate <NSObject>
-(void)loadLmSellerListDataSucceed;
-(void)loadLmSellerListDataFailed:(NSString *)errorMsg;

@end
