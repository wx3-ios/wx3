//
//  LMShopCollectionEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShopCollectionEntity : NSObject
@property (nonatomic,assign) CGFloat score;
@property (nonatomic,strong) NSString *homeImg;
@property (nonatomic,assign) NSInteger shopID;
@property (nonatomic,strong) NSString *shopName;

+(LMShopCollectionEntity*)initShopCollectionData:(NSDictionary*)dic;

@end
