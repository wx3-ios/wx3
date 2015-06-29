//
//  AlipayOBJ.h
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayOBJ : NSObject
@property (nonatomic,retain)NSString *title;
@property (nonatomic,assign)CGFloat price;
@property (nonatomic,assign)BOOL bSelected;

+ (AlipayOBJ*)alipayOBJWith:(NSString*)title price:(CGFloat)price;

@end
