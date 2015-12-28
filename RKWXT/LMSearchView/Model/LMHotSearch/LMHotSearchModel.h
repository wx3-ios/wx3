//
//  LMHotSearchModel.h
//  RKWXT
//
//  Created by SHB on 15/12/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LMSearchHot_Type_Goods = 1,
    LMSearchHot_Type_Shop,
    LMSearchHot_Type_Seller,
}LMSearchHot_Type;

@protocol LMHotSearchModelDelegate;

@interface LMHotSearchModel : NSObject
@property (nonatomic,assign) id<LMHotSearchModelDelegate>delegate;
@property (nonatomic,strong) NSArray *hotSearchList;

-(void)loadLMHotSearchData:(LMSearchHot_Type)type;
@end

@protocol LMHotSearchModelDelegate <NSObject>
-(void)loadLMHotSearchDataSucceed;
-(void)loadLMHotSearchDataFailed:(NSString*)errorMsg;

@end
