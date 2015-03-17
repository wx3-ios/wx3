//
//  ShopDescribtion.h
//  Woxin2.0
//
//  Created by Elty on 12/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDesc : NSObject
@property (nonatomic,assign)NSInteger uID;
@property (nonatomic,retain)NSString *imageURL;
@property (nonatomic,retain)NSString *desc;

+ (ShopDesc*)shopDescribtionWithDictionary:(NSDictionary*)dictionary;
@end
