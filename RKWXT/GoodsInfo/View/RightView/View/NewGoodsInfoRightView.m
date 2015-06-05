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

#define kAnimatedDur 0.3
#define kMaskMaxAlpha 0.6

typedef enum{
    DropListStatus_close = 0,
    DropListStatus_open,
}DropListStatus;

@interface NewGoodsInfoRightView()<WXMaskViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    //背景
    WXMaskView *_bigView;
    //dropListview的superView
    WXUIView *_clipeview;
    UITableView *_tableView;
    
    DropListStatus _dropListStatus;
    CGRect _originListRect;
}
@property (nonatomic,strong) UIButton *menuBtn;
@end

@implementation NewGoodsInfoRightView

-(id)initWithFrame:(CGRect)frame menuButton:(UIButton *)menuButton dropListFrame:(CGRect)dropListFrame{
    self = [super initWithFrame:frame];
    if(self){
        _bigView = [[WXMaskView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
        [_bigView setDelegate:self];
        [_bigView setBackgroundColor:[UIColor blackColor]];
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
    }
    return self;
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            height = NewRightCellHeight;
            break;
            
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell*)tableViewForRightHeadCell{
    static NSString *identifier = @"headCell";
    NewRightHeadCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewRightHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    if(section == 0){
        cell = [self tableViewForRightHeadCell];
    }
    return cell;
}

-(void)buyNow{
    
}

@end
