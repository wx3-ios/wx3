//
//  LMSellerClassifyDropListView.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerClassifyDropListView.h"
#import "LMSellerClassifyDropListCell.h"
#import "WXMaskView.h"
#import "ShopUnionClassifyEntity.h"

#define kAnimatedDur 0.3
#define kMaskMaxAlpha 0.6

typedef enum{
    DropListStatus_Close = 0,
    DropListStatus_Open,
}DropListStatus;

@interface LMSellerClassifyDropListView()<UITableViewDataSource,UITableViewDelegate,WXMaskViewDelegate,LMSellerClassifyDropListCellDelegate>{
    UITableView *_tableView;
    WXMaskView *_maskView;
    WXUIView *_clipeView;
    
    DropListStatus _dropListStatus;
    CGRect _originListRect;
    
    NSArray *listArr;
}
@property (nonatomic,strong) WXUIButton *menuBtn;
@end

@implementation LMSellerClassifyDropListView

-(id)initWithFrame:(CGRect)frame menuButton:(WXUIButton *)menuButton dropListFrame:(CGRect)dropListFrame withData:(NSArray *)dataArr{
    self = [super initWithFrame:frame];
    if(self){
        listArr = dataArr;
        
        [self setUserInteractionEnabled:YES];
        [self setFrame:CGRectMake(0, 44, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT-44)];
        _maskView = [[WXMaskView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
        [_maskView setDelegate:self];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        [_maskView setAlpha:kMaskMaxAlpha];
        [self addSubview:_maskView];
        
        //保存dropList的原始尺寸
        _originListRect = dropListFrame;
        
        _clipeView = [[WXUIView alloc] initWithFrame:dropListFrame];
        [_clipeView setClipsToBounds:YES];
        [self addSubview:_clipeView];
        
        _tableView = [[UITableView alloc] initWithFrame:_clipeView.bounds];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView delaysContentTouches];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_clipeView addSubview:_tableView];
        
        self.menuBtn = menuButton;
        [_menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _dropListStatus = DropListStatus_Open;
    }
    return self;
}

-(void)menuBtnClick{
    if(_dropListStatus == DropListStatus_Open){
        [self showAnimated:YES];
        [_tableView reloadData];
    }else{
        [self unshow:YES];
    }
}

-(void)maskViewIsClicked{
    [self unshow:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LMSellerDropList_MaskviewClicked object:nil];
}

-(void)showAnimated:(BOOL)animated{
    [self setHidden:NO];
    [_maskView setAlpha:0.0];
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeView setFrame:_originListRect];
            [_maskView setAlpha:kMaskMaxAlpha];
        }completion:^(BOOL finished) {
        }];
    }else{
        [_clipeView setFrame:_originListRect];
        [_maskView setAlpha:kMaskMaxAlpha];
    }
    _dropListStatus = DropListStatus_Close;
}

-(void)unshow:(BOOL)animated{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, 0);
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeView setFrame:rect];
            [_maskView setAlpha:0.0];
        }completion:^(BOOL finished) {
            [self setHidden:YES];
        }];
    }else{
        [_clipeView setFrame:rect];
        [_maskView setAlpha:0.0];
        [self setHidden:YES];
    }
    _dropListStatus = DropListStatus_Open;
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count]/4+([listArr count]%4>0?1:0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(WXUITableViewCell *)lmSellerClassifyDropListCell:(NSInteger)row{
    static NSString *identifier = @"dropListCell";
    LMSellerClassifyDropListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSellerClassifyDropListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*4;
    NSInteger count = [listArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*4; i < max; i++){
        [rowArray addObject:[listArr objectAtIndex:i]];
    }
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self lmSellerClassifyDropListCell:row];
    return cell;
}

#pragma mark droplistDelegate
-(void)lmSellerListBtnClicked:(id)sender{
    ShopUnionClassifyEntity *entity = sender;
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:entity.industryName forKey:@"industryName"];
    
    [self unshow:YES];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    if(_delegate && [_delegate respondsToSelector:@selector(changeSellerName:)]){
        [_delegate changeSellerName:entity.industryName];
    }
}

@end
