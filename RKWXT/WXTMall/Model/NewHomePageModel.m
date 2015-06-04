//
//  NewHomePageModel.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewHomePageModel.h"

@interface NewHomePageModel(){
    HomePageTop *_top;
    HomePageRecModel *_recommend;
    HomePageThemeModel *_theme;
    HomePageSurpModel *_surprise;
}
@end

@implementation NewHomePageModel

-(id)init{
    if(self = [super init]){
        _top = [[HomePageTop alloc] init];
        _recommend = [[HomePageRecModel alloc] init];
        _theme = [[HomePageThemeModel alloc] init];
        _surprise = [[HomePageSurpModel alloc] init];
    }
    return self;
}

-(void)toInit{
    [_top toInit];
    [_recommend toInit];
    [_theme toInit];
    [_surprise toInit];
}

-(void)setDelegate:(id<HomePageTopDelegate,HomePageRecDelegate,HomePageThemeDelegate,HomePageSurpDelegate>)delegate{
    [_top setDelegate:delegate];
    [_recommend setDelegate:delegate];
    [_theme setDelegate:delegate];
    [_surprise setDelegate:delegate];
}

-(BOOL)isSomeDataNeedReload{
    return [_top dataNeedReload] || [_recommend dataNeedReload] || [_theme dataNeedReload] || [_surprise dataNeedReload];
}

-(void)loadData{
    if([_top dataNeedReload]){
        [_top loadData];
    }
    if([_recommend dataNeedReload]){
        [_recommend loadData];
    }
    if([_theme dataNeedReload]){
        [_theme loadData];
    }
    if([_surprise dataNeedReload]){
        [_surprise loadData];
    }
}

@end
