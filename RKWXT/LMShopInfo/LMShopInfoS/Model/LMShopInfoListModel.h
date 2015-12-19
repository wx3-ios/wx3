//
//  LMShopInfoListModel.h
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LMShopInfo_DataType_AllGoods = 1,
    LMShopInfo_DataType_ComGoods,
    LMShopInfo_DataType_Active,
}LMShopInfo_DataType;


@protocol LMShopInfoListModelDelegate;
@interface LMShopInfoListModel : NSObject
@property (nonatomic,assign) id<LMShopInfoListModelDelegate>delegate;
@property (nonatomic,strong) NSArray *data;

-(void)loadShopInfoListDataWith:(LMShopInfo_DataType)dataTpe and:(NSInteger)sshop_id andStartItem:(NSInteger)startItem andLenth:(NSInteger)length;

@end

@protocol LMShopInfoListModelDelegate <NSObject>
-(void)loadShopListDataSucced;
-(void)loadShopListDataFailed:(NSString*)errorMsg;

@end
