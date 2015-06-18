//
//  NewGoodsInfoRightView.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoRightView.h"
#import "WXMaskView.h"
#import "NewRightHeadCell.h"
#import "RightVieGoodsInfoTypeCell.h"
#import "RightGoodsStoreCell.h"
#import "RightGoodsSelNumCell.h"

#define kAnimatedDur 0.3
#define kMaskMaxAlpha 0.6

typedef enum{
    DropListStatus_close = 0,
    DropListStatus_open,
}DropListStatus;

enum{
    RightView_Section_BaseInfo = 0,
    RightView_Section_GoodsType,
    RightView_Section_GoodsStore,
    RightView_Section_GoodsSelNum,
    
    RightView_Section_Invalid
};

@interface NewGoodsInfoRightView()<WXMaskViewDelegate,UITableViewDataSource,UITableViewDelegate,RightGoodsTypeCellDelegate,RightGoodsSelNumCellDelegate>{
    //背景
    WXMaskView *_bigView;
    //dropListview的superView
    WXUIView *_clipeview;
    UITableView *_tableView;
    
    DropListStatus _dropListStatus;
    CGRect _originListRect;
    
    GoodsInfoEntity *ent;
    NSInteger selNumber;
}
@property (nonatomic,strong) UIButton *menuBtn;
@end

@implementation NewGoodsInfoRightView

-(id)initWithFrame:(CGRect)frame menuButton:(UIButton *)menuButton dropListFrame:(CGRect)dropListFrame{
    self = [super initWithFrame:frame];
    if(self){
        _bigView = [[WXMaskView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
        [_bigView setDelegate:self];
        [_bigView setBackgroundColor:[UIColor whiteColor]];
        [_bigView setAlpha:kMaskMaxAlpha];
        [self addSubview:_bigView];
        
        //保存dropLis的原始尺寸
        _originListRect = dropListFrame;
        
        _clipeview = [[WXUIView alloc] initWithFrame:dropListFrame];
        [_clipeview setClipsToBounds:YES];
        [self addSubview:_clipeview];
        
        CGRect rect = CGRectMake(_clipeview.bounds.origin.x, _clipeview.bounds.origin.y, _clipeview.bounds.size.width, _clipeview.bounds.size.height-46);
        _tableView = [[UITableView alloc] init];
        _tableView.frame = rect;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setAlpha:0.9];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_clipeview addSubview:_tableView];
        [_clipeview addSubview:[self tableViewForFootView]];
        
        self.menuBtn = menuButton;
        [_menuBtn addTarget:self action:@selector(menuButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _dropListStatus = DropListStatus_open;
        [self addNotification];
    }
    return self;
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGoodsInfoSucceed) name:K_Notification_GoodsInfo_LoadSucceed object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView *)tableViewForFootView{
    UIView *footView = [[UIView alloc] init];
    [footView setBackgroundColor:[UIColor redColor]];
    
    WXUIButton *buyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(0, 0, _originListRect.size.width, 46);
    [buyBtn setBackgroundColor:WXColorWithInteger(0xbb2726)];
    [buyBtn setTitle:@"确定" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyNow) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:buyBtn];
    
    footView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-46, _originListRect.size.width, 46);
    return footView;
}

-(void)showDropListUpView{
    
}

-(void)menuButtonClick{
    if(_dropListStatus == DropListStatus_open){
        [self showAnimated:YES];
    }else{
        [self unshow:YES];
    }
}

-(void)showAnimated:(BOOL)animated{
    [self setHidden:NO];
    [_bigView setAlpha:0.0];
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeview setFrame:_originListRect];
            [_bigView setAlpha:kMaskMaxAlpha];
        }completion:^(BOOL finished) {
        }];
    }else{
        [_clipeview setFrame:_originListRect];
        [_bigView setAlpha:kMaskMaxAlpha];
    }
    _dropListStatus = DropListStatus_close;
}

-(void)unshow:(BOOL)animated{
    CGRect rect = CGRectMake(self.bounds.size.width, 0, 0, self.bounds.size.height);
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeview setFrame:rect];
            [_bigView setAlpha:0.0];
        }completion:^(BOOL finished) {
            [self setHidden:YES];
        }];
    }else{
        [_clipeview setFrame:rect];
        [self setHidden:YES];
        [_bigView setAlpha:0.0];
    }
    _dropListStatus = DropListStatus_open;
}

-(void)maskViewIsClicked{
    [self unshow:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MaskViewClicked object:nil];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return RightView_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case RightView_Section_BaseInfo:
            row = 1;
            break;
        case RightView_Section_GoodsType:
            row = [_dataArr count];
            break;
        case RightView_Section_GoodsStore:
            row = 1;
            break;
        case RightView_Section_GoodsSelNum:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case RightView_Section_BaseInfo:
            height = NewRightCellHeight;
            break;
        case RightView_Section_GoodsType:
            height = RightVieGoodsInfoTypeCellHeight;
            break;
        case RightView_Section_GoodsStore:
            height = RightGoodsStoreCellHeight;
            break;
        case RightView_Section_GoodsSelNum:
            height = RightGoodsSelNumCellHeight;
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 20;
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, self.bounds.size.width, 10);
    [headView setBackgroundColor:[UIColor whiteColor]];
    return headView;
}

-(WXUITableViewCell*)tableViewForRightHeadCell{
    static NSString *identifier = @"headCell";
    NewRightHeadCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewRightHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_dataArr count] > 0){
        [cell setCellInfo:[_dataArr objectAtIndex:0]];
    }
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForRightGoodsTypeAtRow:(NSInteger)row{
    static NSString *identifier = @"goodsTypeCell";
    RightVieGoodsInfoTypeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RightVieGoodsInfoTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setGoodsEntity:ent];
    [cell setCellInfo:[_dataArr objectAtIndex:row]];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForRightGoodsStore{
    static NSString *identifier = @"goodsStoreCell";
    RightGoodsStoreCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RightGoodsStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:ent];
    [cell setNumber:selNumber];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForRightGoodsSelNumCell{
    static NSString *identifier = @"goodsSelNumCell";
    RightGoodsSelNumCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RightGoodsSelNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegte:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case RightView_Section_BaseInfo:
            cell = [self tableViewForRightHeadCell];
            break;
        case RightView_Section_GoodsType:
            cell = [self tableViewForRightGoodsTypeAtRow:row];
            break;
        case RightView_Section_GoodsStore:
            cell = [self tableViewForRightGoodsStore];
            break;
        case RightView_Section_GoodsSelNum:
            cell = [self tableViewForRightGoodsSelNumCell];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark goodsTypeDelegate
-(void)selectGoodsType:(id)sender{
    ent = sender;
    [_tableView reloadData];
}

#pragma mark goodsSelNumDelegate
-(void)setGoodsSelNumber:(NSInteger)number{
    if(number<=0){
        return;
    }
    selNumber = number;
    [_tableView reloadData];
}

-(void)loadGoodsInfoSucceed{
    [_tableView reloadData];
}

-(void)buyNow{
    
}

@end
