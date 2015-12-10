//
//  LMSearchHistoryEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSearchHistoryEntity : NSObject
@property (nonatomic,assign) NSInteger recordTime;
@property (nonatomic,strong) NSString *recordName;
@property (nonatomic,strong) NSString *recordID;
@property (nonatomic,strong) NSString *other; //预留

@end
