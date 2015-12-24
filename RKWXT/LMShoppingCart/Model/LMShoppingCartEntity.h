//
//  LMShoppingCartEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShoppingCartEntity : NSObject
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) NSInteger buyNumber;
@property (nonatomic,assign) CGFloat goodsPrice;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) NSInteger stockNumber;

@property (nonatomic,assign) NSInteger cartID;
@property (nonatomic,assign) NSInteger shopID;
@property (nonatomic,strong) NSString *shopName;

@property (nonatomic,strong) NSArray *goodsArr;

//临时数据
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL selectAll;
@property (nonatomic,assign) BOOL edit;

+(LMShoppingCartEntity*)initLMShoppCartEntity:(NSDictionary*)dic;

@end
