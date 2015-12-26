//
//  LMSearchDataModel.h
//  RKWXT
//
//  Created by SHB on 15/12/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LMSearch_Type_Goods = 1,
//    LMSearch_Type_Shop = 2,
    LMSearch_Type_Seller = 3,
}LMSearch_Type;

@protocol LMSearchDataModelDelegate;

@interface LMSearchDataModel : NSObject
@property (nonatomic,assign) id<LMSearchDataModelDelegate>delegate;
@property (nonatomic,strong) NSArray *searchListArr;

-(void)lmSearchInputKeyword:(NSString*)keyword searchType:(LMSearch_Type)type;
@end

@protocol LMSearchDataModelDelegate <NSObject>
-(void)lmSearchDataSucceed;
-(void)lmSearchDataFailed:(NSString*)errorMsg;

@end
