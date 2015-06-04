//
//  HomePageThemeModel.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HomePageThemeModel.h"
#import "HomePageThmEntity.h"

@interface HomePageThemeModel(){
    NSMutableArray *_dataList;
}
@end

@implementation HomePageThemeModel
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

@end
