//
//  WXShopUnionAreaView.m
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionAreaView.h"
#import "WXMaskView.h"
#import "WXShopCityListVC.h"
#import "WXShopUnionAreaListCell.h"
#import "WXShopUnionCityChooseCell.h"

#define kAnimatedDur 0.3
#define kMaskMaxAlpha 0.6

typedef enum{
    DropListStatus_Close = 0,
    DropListStatus_Open,
}DropListStatus;

enum{
    ShopUnionArea_Section_AreaList = 0,
    ShopUnionArea_Section_CityChoose,
    
    ShopUnionArea_Section_Invalid,
};

@interface WXShopUnionAreaView()<UITableViewDataSource,UITableViewDelegate,WXMaskViewDelegate,WXShopUnionAreaListCellDelegate>{
    WXMaskView *_bigView;
    WXUIView *_clipeView;
    UITableView *_tableView;
    
    DropListStatus _dropListStatus;
    CGRect _originListRect;
    
    //测试
    NSArray *listArea;
}
@property (nonatomic,strong) WXUIButton *menuBtn;
@end

@implementation WXShopUnionAreaView

-(id)initWithFrame:(CGRect)frame menuButton:(WXUIButton *)menuButton dropListFrame:(CGRect)dropListFrame{
    self = [super initWithFrame:frame];
    if(self){
        _bigView = [[WXMaskView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, IPHONE_SCREEN_HEIGHT)];
        [_bigView setAlpha:0.0];
        [_bigView setDelegate:self];
        [_bigView setBackgroundColor:[UIColor blackColor]];
        [_bigView setAlpha:kMaskMaxAlpha];
        [self addSubview:_bigView];
        
        //保存dropList的原始尺寸
        _originListRect = dropListFrame;
        
        _clipeView = [[WXUIView alloc] initWithFrame:dropListFrame];
        [_clipeView setClipsToBounds:YES];
        [self addSubview:_clipeView];
        
        _tableView = [[UITableView alloc] initWithFrame:_clipeView.bounds];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView delaysContentTouches];
        [_tableView setBackgroundColor:WXColorWithInteger(0xF0F0F0)];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_clipeView addSubview:_tableView];
        
        self.menuBtn = menuButton;
        [_menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _dropListStatus = DropListStatus_Open;
        
        listArea = @[@"龙岗区", @"龙华新区", @"罗湖区", @"南山区", @"盐田区", @"宝安区"];
        CGRect rect = self.bounds;
        rect.size.height = 170;
        [self setFrame:rect];
        _originListRect = rect;
    }
    return self;
}

-(void)selectCityArea{
}

-(void)menuBtnClick{
    if(_dropListStatus == DropListStatus_Open){
        [self showAnimated:YES];
    }else{
        [self unshow:YES];
    }
}

-(void)maskViewIsClicked{
    [self unshow:YES];
}

-(void)showAnimated:(BOOL)animated{
    [self setHidden:NO];
    [_bigView setAlpha:0.0];
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeView setFrame:_originListRect];
            [_bigView setAlpha:kMaskMaxAlpha];
        }completion:^(BOOL finished) {
        }];
    }else{
        [_clipeView setFrame:_originListRect];
        [_bigView setAlpha:kMaskMaxAlpha];
    }
    _dropListStatus = DropListStatus_Close;
}

-(void)unshow:(BOOL)animated{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, 0);
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeView setFrame:rect];
            [_bigView setAlpha:0.0];
        }completion:^(BOOL finished) {
            [self setHidden:YES];
        }];
    }else{
        [_clipeView setFrame:rect];
        [_bigView setAlpha:0.0];
        [self setHidden:YES];
    }
    _dropListStatus = DropListStatus_Open;
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ShopUnionArea_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case ShopUnionArea_Section_AreaList:
            row = [listArea count]/3+([listArea count]%3>0?1:0);
            break;
        case ShopUnionArea_Section_CityChoose:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section == ShopUnionArea_Section_AreaList){
        height = 15;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section == ShopUnionArea_Section_AreaList){
        height = 15;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    switch (section) {
        case ShopUnionArea_Section_AreaList:
            height = 40;
            break;
        case ShopUnionArea_Section_CityChoose:
            height = 44;
            break;
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell *)shopUnionAreaListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"areaListCell";
    WXShopUnionAreaListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXShopUnionAreaListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    [cell disableTouchDelay];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*3;
    NSInteger count = [listArea count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*3; i < max; i++){
        [rowArray addObject:[listArea objectAtIndex:i]];
    }
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(WXUITableViewCell *)shopUnionCityChooseCell{
    static NSString *identifier = @"cityCell";
    WXShopUnionCityChooseCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXShopUnionCityChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case ShopUnionArea_Section_AreaList:
            cell = [self shopUnionAreaListCellAtRow:row];
            break;
        case ShopUnionArea_Section_CityChoose:
            cell = [self shopUnionCityChooseCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark
-(void)shopUnionAreaClicked:(id)entity{
    
}

@end
