//
//  LMOrderListModel.h
//  RKWXT
//
//  Created by SHB on 15/12/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LMOrderList_Type_All = 0,
    LMOrderList_Type_WaitPay,
    LMOrderList_Type_WaitReceived,
    LMOrderList_Type_WaitEvaluate,
}LMOrderList_Type;

@protocol LMOrderListModelDelegate;

@interface LMOrderListModel : NSObject
@property (nonatomic,assign) id<LMOrderListModelDelegate>delegate;
@property (nonatomic,strong) NSArray *orderList;

-(void)loadLMOrderList:(NSInteger)startItem andLength:(NSInteger)length type:(LMOrderList_Type)orderType;
@end

@protocol LMOrderListModelDelegate <NSObject>
-(void)loadLMOrderlistSucceed;
-(void)loadLMOrderlistFailed:(NSString*)errorMsg;

@end
