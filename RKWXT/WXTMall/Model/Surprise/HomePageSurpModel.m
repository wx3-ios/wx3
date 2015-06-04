//
//  HomePageSurpModel.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageSurpModel.h"
#import "HomePageSurpEntity.h"

@interface HomePageSurpModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageSurpModel
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
