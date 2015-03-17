//
//  TxtparseOBJ.m
//  Test
//
//  Created by Elty.Le on 12/7/13.
//  Copyright (c) 2013 Elty.Le. All rights reserved.
//

#import "TxtparseOBJ.h"

@implementation TxtparseOBJ

+ (NSArray*)elementsFrom:(NSString*)originString separator:(NSString*)separator{
    if(!originString){
        return nil;
    }
    if(!separator){
        return [NSArray arrayWithObject:originString];
    }
    NSMutableArray *itemArray = [NSMutableArray array];
    NSArray *array = [originString componentsSeparatedByString:separator];
    for(NSString*string in array){
        if([string length] > 0){
            [itemArray addObject:string];
        }
    }
    return itemArray;
}

+ (NSArray*)parseDataFrom:(NSString*)originString itemSeparator:(NSString*)itemSeparator elementSeparator:(NSString*)elementSeparator{
    if(!originString){
        return nil;
    }
    NSMutableArray *itemArray = [NSMutableArray array];
    NSArray *subStrings = [self elementsFrom:originString separator:itemSeparator];
    
    NSAutoreleasePool *poor = [[NSAutoreleasePool alloc] init];
    for(NSString *string in subStrings){
        NSArray *_subStrings = [self elementsFrom:string separator:elementSeparator];
        if(_subStrings && [_subStrings count] > 0){
            [itemArray addObject:_subStrings];
        }
    }
    [poor drain];
    return itemArray;
}
@end
