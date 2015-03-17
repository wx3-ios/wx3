//
//  TxtparseOBJ.h
//  Test
//
//  Created by Elty.Le on 12/7/13.
//  Copyright (c) 2013 Elty.Le. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TxtparseOBJ : NSObject

+ (NSArray*)parseDataFrom:(NSString*)filePath itemSeparator:(NSString*)itemSeparator elementSeparator:(NSString*)elementSeparator;
@end
