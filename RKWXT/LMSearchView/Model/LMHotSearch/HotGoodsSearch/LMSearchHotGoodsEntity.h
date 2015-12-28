//
//  LMSearchHotGoodsEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSearchHotGoodsEntity : NSObject
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) NSInteger searchID;

+(LMSearchHotGoodsEntity*)initLMSearchHotGoodsEntity:(NSDictionary*)dic;

@end
