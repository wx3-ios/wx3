//
//  LMSearchSellerEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSearchSellerEntity : NSObject
@property (nonatomic,assign) NSInteger sellerID;
@property (nonatomic,strong) NSString *sellerName;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *address;

+(LMSearchSellerEntity*)initLMSearchSellerEntity:(NSDictionary*)dic;

@end
