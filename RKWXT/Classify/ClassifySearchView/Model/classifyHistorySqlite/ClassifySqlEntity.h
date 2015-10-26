//
//  ClassifySqlEntity.h
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifySqlEntity : NSObject
@property (nonatomic,assign) NSInteger recordTime;
@property (nonatomic,strong) NSString *recordName;
@property (nonatomic,strong) NSString *recordID;
@property (nonatomic,strong) NSString *other; //预留

@end
