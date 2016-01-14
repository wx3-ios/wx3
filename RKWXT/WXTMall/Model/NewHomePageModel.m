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
    HomeNavModel *_navModel;
    HomeLimitBuyModel *_limitModel;
}
@end

@implementation NewHomePageModel

-(id)init{
    if(self = [super init]){
        _top = [[HomePageTop alloc] init];
        _recommend = [[HomePageRecModel alloc] init];
        _theme = [[HomePageThemeModel alloc] init];
        _surprise = [[HomePageSurpModel alloc] init];
        _navModel = [[HomeNavModel alloc] init];
        _limitModel = [[HomeLimitBuyModel alloc] init];
    }
    return self;
}

-(void)toInit{
    [_top toInit];
    [_recommend toInit];
    [_theme toInit];
    [_surprise toInit];
    [_navModel toInit];
    [_limitModel toInit];
}

-(void)setDelegate:(id<HomePageTopDelegate,HomePageRecDelegate,HomePageThemeDelegate,HomePageSurpDelegate,HomeNavModelDelegate,HomeLimitBuyModelDelegate>)delegate{
    [_top setDelegate:delegate];
    [_recommend setDelegate:delegate];
    [_theme setDelegate:delegate];
    [_surprise setDelegate:delegate];
    [_navModel setDelegate:delegate];
    [_limitModel setDelegate:delegate];
}

-(BOOL)isSomeDataNeedReload{
    return [_top dataNeedReload] || [_recommend dataNeedReload] || [_theme dataNeedReload] || [_surprise dataNeedReload] || [_navModel dataNeedReload] || [_limitModel dataNeedReload];
}

-(void)loadData{
    [_top loadData];
    [_recommend loadData];
    [_theme loadData];
    [_surprise loadData];
    [_navModel loadData];
    [_limitModel loadData];
//    if([_top dataNeedReload]){
//        [_top loadData];
//    }
//    if([_recommend dataNeedReload]){
//        [_recommend loadData];
//    }
//    if([_theme dataNeedReload]){
//        [_theme loadData];
//    }
//    if([_surprise dataNeedReload]){
//        [_surprise loadData];
//    }
//    if([_navModel dataNeedReload]){
//        [_navModel loadData];
//    }
//    if([_limitModel dataNeedReload]){
//        [_limitModel loadData];
//    }
}

@end
