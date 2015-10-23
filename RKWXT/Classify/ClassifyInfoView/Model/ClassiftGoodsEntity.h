//
//  ClassiftGoodsEntity.h
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassiftGoodsEntity : NSObject
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,strong) NSString *goodsName;

+(ClassiftGoodsEntity*)initCLassifyGoodsListData:(NSDictionary*)dic;

@end
