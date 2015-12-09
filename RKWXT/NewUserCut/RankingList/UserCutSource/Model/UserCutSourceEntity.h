//
//  UserCutSourceEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCutSourceEntity : NSObject
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *registerTime;
@property (nonatomic,assign) CGFloat money;
@property (nonatomic,assign) NSInteger wxID;

+(UserCutSourceEntity*)initUserCutSourceEntityWith:(NSDictionary*)dic;

@end
