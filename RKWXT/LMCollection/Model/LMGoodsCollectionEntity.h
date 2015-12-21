//
//  LMGoodsCollectionEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMGoodsCollectionEntity : NSObject
@property (nonatomic,strong) NSString *homeImg;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) CGFloat marketPrice;
@property (nonatomic,assign) CGFloat shopPrice;
@property (nonatomic,assign) NSInteger shopID;

+(LMGoodsCollectionEntity*)initGoodsCollectionEntity:(NSDictionary*)dic;

@end
