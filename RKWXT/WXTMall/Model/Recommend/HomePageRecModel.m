//
//  HomePageRecModel.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageRecModel.h"
#import "HomePageRecEntity.h"

@interface HomePageRecModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageRecModel
@synthesize data = _dataList;

-(id)init{
    self = [super init];
    if(self){
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

@end
