//
//  LMSearchGoodsEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSearchGoodsEntity : NSObject
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) CGFloat marketPrice;;
@property (nonatomic,assign) CGFloat shopPrice;

+(LMSearchGoodsEntity*)initLMSearchGoodsEntity:(NSDictionary*)dic;

@end
