//
//  Sql_JpushData.h
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sql_JpushData : NSObject

-(BOOL)insertData:(NSString*)content withAbs:(NSString*)abstract withImg:(NSString*)mesImg;

@end
