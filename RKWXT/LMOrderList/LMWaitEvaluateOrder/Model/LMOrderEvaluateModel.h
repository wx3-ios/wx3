//
//  LMOrderEvaluateModel.h
//  RKWXT
//
//  Created by SHB on 15/12/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OrderEvaluate_Type_Add = 1,  //添加评价
    OrderEvaluate_Type_LMSearch, //商家联盟查询
    OrderEvaluate_Type_AppSearch, // app查询
}OrderEvaluate_Type;

@protocol LMOrderEvaluateModelDelegate;

@interface LMOrderEvaluateModel : NSObject
@property (nonatomic,assign) id<LMOrderEvaluateModelDelegate>delegate;

-(void)userEvaluateOrder:(NSInteger)orderID andInfo:(NSString*)content type:(OrderEvaluate_Type)type;
@end

@protocol LMOrderEvaluateModelDelegate <NSObject>
-(void)lmOrderEvaluateSucceed;
-(void)lmOrderEvaluateFailed:(NSString*)errorMsg;

@end
