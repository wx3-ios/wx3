//
//  CityAddress.m
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "CityAddress.h"

@implementation CityAddress

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)loadUserAddressData{
    NSBundle *bundel = [NSBundle mainBundle];
    NSString *plistPath = [bundel pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2){
        if([obj1 integerValue] > [obj2 integerValue]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if([obj1 integerValue] < [obj2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for(int i = 0; i < [sortedArray count]; i++){
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey:index] allKeys];
        [provinceTmp addObject:[tmp objectAtIndex:0]];
    }
    
    _province = [[NSArray alloc] initWithArray:provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [_province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[_areaDic objectForKey:index] objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:[dic objectForKey:[cityArray objectAtIndex:0]]];
    _city = [[NSArray alloc] initWithArray:[cityDic allKeys]];
    
    NSString *selectedCity = [_city objectAtIndex:0];
    _district = [[NSArray alloc] initWithArray:[cityDic objectForKey:selectedCity]];
    
    _selectedProvince  = [_province objectAtIndex:0];
}

@end
