//
//  ShareModel.h
//  RKWXT
//
//  Created by app on 16/4/20.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject
+ (void)shareInfoWith:(void(^)(NSString *share))str;
@end
