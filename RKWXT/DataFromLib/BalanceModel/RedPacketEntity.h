//
//  RedPacketEntity.h
//  Woxin2.0
//
//  Created by Elty on 11/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPacketEntity : NSObject
@property (nonatomic,assign)NSInteger rpID; //红包ID
@property (nonatomic,assign)CGFloat money;//金额
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)NSString *remark;
@property (nonatomic,assign)NSInteger endDate;
//以下目前都没有用~ 
@property (nonatomic,assign)NSInteger type; //红包类型
@property (nonatomic,assign)NSInteger shopID; //店铺ID
@property (nonatomic,retain)NSString *shopName;


@end
