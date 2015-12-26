//
//  LMHomeMoreHotGoodsModel.h
//  RKWXT
//
//  Created by SHB on 15/12/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMHomeMoreHotGoodsModelDelegate;

@interface LMHomeMoreHotGoodsModel : NSObject
@property (nonatomic,assign) id<LMHomeMoreHotGoodsModelDelegate>delegate;
@property (nonatomic,strong) NSArray *listArr;

-(void)loadLMHomeMoreHotGoods:(NSInteger)startItem length:(NSInteger)length;
@end

@protocol LMHomeMoreHotGoodsModelDelegate <NSObject>
-(void)loadMoreHotGoodsSucceed;
-(void)loadMoreHotGoodsFailed:(NSString*)errorMsg;

@end
