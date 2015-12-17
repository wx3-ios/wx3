//
//  LMSellerListEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSellerListEntity : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) CGFloat distance;
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat lonitude;
@property (nonatomic,strong) NSString *sellerImg;
@property (nonatomic,assign) NSInteger sellerId;
@property (nonatomic,strong) NSString *sellerName;

+(LMSellerListEntity*)initSellerListEntityWidth:(NSDictionary*)dic;

@end
