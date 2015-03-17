//
//  BaseSearchEntity.h
//  WXServer
//
//  Created by le ting on 6/12/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseSearchEntity : NSObject

- (BOOL)matchingString:(NSString*)string;
@end
