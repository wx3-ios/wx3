//
//  HomeNavModel.m
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomeNavModel.h"
#import "HomeNavENtity.h"

@interface HomeNavModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomeNavModel
@synthesize data = _dataList;

-(id)init{
    if(self = [super init]){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

-(void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
    
}

-(void)loadDataFromWeb{
    
}

-(void)loadCacheDataSucceed{
    
}

@end
