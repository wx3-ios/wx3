//
//  WXContactOptEntity.h
//  Woxin2.0
//
//  Created by le ting on 7/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ContactBaseEntity.h"

@interface WXContactOptEntity : ContactBaseEntity
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)UIImage *icon;
@property (nonatomic,assign)NSInteger numberRight;

+ (WXContactOptEntity*)optEntityWithName:(NSString*)name icon:(UIImage*)icon numberRight:(NSInteger)numberRight;
@end
