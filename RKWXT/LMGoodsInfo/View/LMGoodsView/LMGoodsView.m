//
//  LMGoodsView.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsView.h"
#import "LMGoodsInfoEntity.h"
#import "LMGoodsStockNameCell.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

#define xSide (12)
#define ViewWidth IPHONE_SCREEN_WIDTH-2*xSide
#define ViewHeight IPHONE_SCREEN_WIDTH+50
#define DownViewHeight (70)

@interface LMGoodsView()<UITableViewDataSource,UITableViewDelegate,LMGoodsStockNameCellDelegate>{
    UITableView *_tableView;
    WXUIView *_maskShell;
    WXUIView *_baseView;
    
    WXUILabel *stockNumLabel;
    WXUILabel *pricelaebl;
    WXUILabel *buyNumLabel;
    WXUIButton *buyBtn;
    
    NSArray *listArr;
    NSInteger buyNumber;
}
@end

@implementation LMGoodsView

-(id)init{
    self = [super init];
    if(self){
        [self initBaseInfo];
    }
    return self;
}

-(void)initBaseInfo{
    [self setFrame:CGRectMake(IPHONE_SCREEN_WIDTH/2, IPHONE_SCREEN_HEIGHT/2, 0, 0)];
    
    _maskShell = [[WXUIView alloc] init];
    _maskShell.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    [_maskShell setBackgroundColor:[UIColor blackColor]];
    [_maskShell setAlpha:kMaskShellDefaultAlpha];
    [self addSubview:_maskShell];
    
    CGFloat yOffset = 90;
    _baseView = [[WXUIView alloc] init];
    _baseView.frame = CGRectMake(xSide, yOffset, ViewWidth, ViewHeight);
    [_baseView setBackgroundColor:[UIColor whiteColor]];
    [_baseView setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [self addSubview:_baseView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-ViewWidth)/2, 0, ViewWidth, ViewHeight-DownViewHeight);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_baseView addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableHeaderView]];
    [_tableView setTableFooterView:[self tableFootView]];
    
    [self downViewBtn];
}

-(void)downViewBtn{
    WXUIView *downView = [[WXUIView alloc] init];
    downView.frame = CGRectMake(xSide, ViewHeight-DownViewHeight+90, ViewWidth, DownViewHeight);
    [downView setBackgroundColor:[UIColor clearColor]];
    [_baseView addSubview:downView];
    
    CGFloat xOffset = 10;
    CGFloat btnHeight = 40;
    buyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, ViewWidth-2*xOffset, btnHeight);
    [buyBtn setBorderRadian:4.0 width:1.0 color:[UIColor clearColor]];
    [buyBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [downView addSubview:buyBtn];
    
    [self addSubview:downView];
}

-(WXUIView*)tableHeaderView{
    WXUIView *headerView = [[WXUIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ViewWidth, 44);
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat titleLabelWidth = 80;
    CGFloat titlelabelHeight = 16;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-titleLabelWidth)/2, (44-titlelabelHeight)/2, titleLabelWidth, titlelabelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"选择属性"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:WXFont(10.0)];
    [titleLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
    [headerView addSubview:titleLabel];
    return headerView;
}

-(WXUIView *)tableFootView{
    WXUIView *footView = [[WXUIView alloc] init];
    [footView setBackgroundColor:[UIColor clearColor]];
    
    
    CGFloat yOffset = 15;
    WXUILabel *upLineLabel = [[WXUILabel alloc] init];
    upLineLabel.frame = CGRectMake(0, yOffset, ViewWidth, 0.5);
    [upLineLabel setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [footView addSubview:upLineLabel];
    
    yOffset += 0.5;
    CGFloat yGap = 13;
    CGFloat labelWidth = 90;
    CGFloat labelHeight = 18;
    WXUILabel *stockName = [[WXUILabel alloc] init];
    stockName.frame = CGRectMake((IPHONE_SCREEN_WIDTH/2-labelWidth)/2, yGap+yOffset, labelWidth, labelHeight);
    [stockName setBackgroundColor:[UIColor clearColor]];
    [stockName setText:@"库存"];
    [stockName setTextAlignment:NSTextAlignmentCenter];
    [stockName setFont:WXFont(12.0)];
    [stockName setTextColor:WXColorWithInteger(0x9b9b9b)];
    [footView addSubview:stockName];
    
    yOffset += labelHeight+yGap+18;
    stockNumLabel = [[WXUILabel alloc] init];
    stockNumLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH/2-labelWidth)/2, yOffset, labelWidth, labelHeight);
    [stockNumLabel setBackgroundColor:[UIColor clearColor]];
    [stockNumLabel setTextAlignment:NSTextAlignmentCenter];
    [stockNumLabel setTextColor:WXColorWithInteger(0x000000)];
    [stockNumLabel setFont:WXFont(12.0)];
    [footView addSubview:stockNumLabel];
    
    WXUILabel *plusLabel = [[WXUILabel alloc] init];
    plusLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2+(IPHONE_SCREEN_WIDTH/2-labelWidth)/2, stockName.frame.origin.y, labelWidth, labelHeight);
    [plusLabel setBackgroundColor:[UIColor clearColor]];
    [plusLabel setText:@"合计"];
    [plusLabel setTextAlignment:NSTextAlignmentCenter];
    [plusLabel setFont:WXFont(12.0)];
    [plusLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
    [footView addSubview:plusLabel];
    
    pricelaebl = [[WXUILabel alloc] init];
    pricelaebl.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2+(IPHONE_SCREEN_WIDTH/2-labelWidth)/2, yOffset, labelWidth, labelHeight);
    [pricelaebl setBackgroundColor:[UIColor clearColor]];
    [pricelaebl setTextAlignment:NSTextAlignmentCenter];
    [pricelaebl setTextColor:WXColorWithInteger(0xdd2726)];
    [pricelaebl setFont:WXFont(12.0)];
    [footView addSubview:pricelaebl];
    
    yOffset += labelHeight+15;
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake(ViewWidth/2, 6, 0.5, (yOffset-2*6));
    [lineLabel setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [footView addSubview:lineLabel];
    
    WXUILabel *downLine = [[WXUILabel alloc] init];
    downLine.frame = CGRectMake(0, yOffset, ViewWidth, 0.5);
    [downLine setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [footView addSubview:downLine];
    
    CGFloat numLabelWidth = 50;
    yOffset += 12;
    CGFloat btnWidth = 40;
    CGFloat btnHeight = btnWidth;
    WXUIButton *minusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH/2-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [minusBtn setBackgroundColor:[UIColor clearColor]];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn.titleLabel setFont:WXFont(25.0)];
    [minusBtn setTitleColor:WXColorWithInteger(0x9b9b9b) forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:minusBtn];
    
    buyNumLabel = [[WXUILabel alloc] init];
    buyNumLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-numLabelWidth)/2, yOffset, numLabelWidth, btnHeight);
    [buyNumLabel setBackgroundColor:[UIColor clearColor]];
    [buyNumLabel setTextAlignment:NSTextAlignmentCenter];
    [buyNumLabel setText:@"1"];
    [buyNumLabel setFont:WXFont(14.0)];
    [buyNumLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
    [footView addSubview:buyNumLabel];
    
    WXUIButton *plusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2+(IPHONE_SCREEN_WIDTH/2-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [plusBtn setBackgroundColor:[UIColor clearColor]];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn.titleLabel setFont:WXFont(25.0)];
    [plusBtn setTitleColor:WXColorWithInteger(0x9b9b9b) forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:plusBtn];
    
    yOffset += btnHeight+5;
    footView.frame = CGRectMake(0, 0, ViewWidth, yOffset);
    return footView;
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMGoodsStockNameCellHeight;
}

-(WXUITableViewCell*)goodsStockCell:(NSInteger)row{
    static NSString *identfier = @"stockCell";
    LMGoodsStockNameCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMGoodsStockNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:row]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self goodsStockCell:row];
    return cell;
}

-(void)loadGoodsStockInfo:(NSArray *)stockArr{
    self.hidden = NO;
    self.alpha = 0.0;
    [self setFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    
    if(_goodsViewType == LMGoodsView_Type_ShoppingCart){
        [buyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    
    __block LMGoodsView *blockSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [blockSelf show];
    }];
    
    if([stockArr count] == 0){
        return;
    }
    listArr = stockArr;
    NSInteger count = 0;
    NSInteger stockNumber = 0;
    CGFloat stockPrice = 0;
    for(LMGoodsInfoEntity *entity in listArr){
        if(!entity.selected){
            count ++;
        }else{
            stockNumber = entity.stockNum;
            stockPrice = entity.stockPrice;
        }
    }
    if(count == [listArr count]){
        for(LMGoodsInfoEntity *entity in listArr){
            entity.selected = YES;
            stockNumber = entity.stockNum;
            stockPrice = entity.stockPrice;
            break;
        }
    }
    
    [stockNumLabel setText:[NSString stringWithFormat:@"%ld",(long)stockNumber]];
    [pricelaebl setText:[NSString stringWithFormat:@"￥%.2f",stockPrice]];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)show{
    [self setAlpha:1.0];
}

- (void)unshow{
    [self setAlpha:0.0];
}

- (void)unshowAnimated:(BOOL)animated{
    if (animated){
        __block LMGoodsView *blockSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [blockSelf unshow];
        } completion:^(BOOL finished) {
            [blockSelf removeFromSuperview];
        }];
        
    }else{
        [self removeFromSuperview];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)isClicked{
    [self unshowAnimated:YES];
}

#pragma mark changeBuyNumber
-(void)plusBtnClick{
    CGFloat money = 0;
    for(LMGoodsInfoEntity *entity in listArr){
        if(entity.selected){
            money = entity.stockPrice;
            if(buyNumber >= entity.stockNum){
                return;
            }
        }
    }
    buyNumber ++;
    [buyNumLabel setText:[NSString stringWithFormat:@"%ld",(long)buyNumber]];
    [pricelaebl setText:[NSString stringWithFormat:@"￥%.2f",buyNumber*money]];
}

-(void)minusBtnClicked{
    CGFloat money = 0;
    for(LMGoodsInfoEntity *entity in listArr){
        if(entity.selected){
            money = entity.stockPrice;
        }
    }
    if(buyNumber <= 1){
        return;
    }
    buyNumber--;
    [buyNumLabel setText:[NSString stringWithFormat:@"%ld",(long)buyNumber]];
    [pricelaebl setText:[NSString stringWithFormat:@"￥%.2f",buyNumber*money]];
}

-(void)lmGoodsStockNameBtnClicked:(id)sender{
    LMGoodsInfoEntity *entity = sender;
    for(LMGoodsInfoEntity *ent in listArr){
        if(ent.selected){
            if(ent.stockID == entity.stockID){
                return;
            }else{
                entity.selected = YES;
                ent.selected = NO;
                break;
            }
        }
    }
    buyNumber = 1;
    [_tableView reloadData];
    [stockNumLabel setText:[NSString stringWithFormat:@"%ld",(long)entity.stockNum]];
    [buyNumLabel setText:[NSString stringWithFormat:@"%ld",(long)buyNumber]];
    [pricelaebl setText:[NSString stringWithFormat:@"￥%.2f",entity.stockPrice]];
}

@end
