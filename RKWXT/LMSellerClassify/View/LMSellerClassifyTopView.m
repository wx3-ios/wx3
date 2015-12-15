//
//  LMSellerClassifyTopView.m
//  RKWXT
//
//  Created by SHB on 15/12/14.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerClassifyTopView.h"
#import "ShopUnionClassifyEntity.h"
#import "LMSellerClassifyTopCell.h"
#import "LMSellerClassifyTopTextCell.h"
#import "LMSellerClassifyDropListView.h"

#define ScrollViewHeight (44)
#define RightBtnWidth 36

@interface LMSellerClassifyTopView()<UITableViewDataSource,UITableViewDelegate,LMSellerClassifyDropListViewDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    
    NSString *selectName;
    WXUIButton *arrowBtn;
    BOOL showDownView;
    
    LMSellerClassifyDropListView *sellerDropListView;
}
@end

@implementation LMSellerClassifyTopView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUserInteractionEnabled:YES];
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initBaseTableView];
        [self createRightBtnView];
        [self addOBS];
    }
    return self;
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maskViewClicked) name:K_Notification_Name_LMSellerDropList_MaskviewClicked object:nil];
}

-(void)initBaseTableView{
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    _tableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.frame = CGRectMake(0, 44, IPHONE_SCREEN_WIDTH-RightBtnWidth, ScrollViewHeight);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
}

-(void)createRightBtnView{
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-RightBtnWidth+1, (ScrollViewHeight-20)/2, 0.5, 20);
    [lineLabel setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineLabel];
    
    CGFloat btnWidth = 30;
    CGFloat btnHieght = btnWidth;
    arrowBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn.frame = CGRectMake(lineLabel.frame.origin.x+1+(RightBtnWidth-2-btnWidth)/2, (ScrollViewHeight-btnHieght)/2, btnWidth, btnHieght);
    [arrowBtn setBackgroundColor:[UIColor clearColor]];
    [arrowBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
    [arrowBtn addTarget:self action:@selector(arrowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:arrowBtn];
}

-(LMSellerClassifyDropListView*)createSellerDropListViewWith:(WXUIButton*)btn{
    CGFloat width = self.bounds.size.width;
    CGFloat height = (3+40*([listArr count]/4+([listArr count]%4>0?1:0)));
    CGRect rect = CGRectMake(0, 0, width, height);
    sellerDropListView = [[LMSellerClassifyDropListView alloc] initWithFrame:self.bounds menuButton:btn dropListFrame:rect withData:listArr];
    [sellerDropListView setDelegate:self];
    return sellerDropListView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!showDownView){
        return 1;
    }
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!showDownView){
        return 44;
    }
    return [LMSellerClassifyTopCell cellHeightOfInfo:[listArr objectAtIndex:indexPath.row]]+15;
}

-(WXUITableViewCell*)topTextCell{
    static NSString *identifier = @"textCell";
    LMSellerClassifyTopTextCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSellerClassifyTopTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:listArr];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)topClassifySellerNameCell:(NSInteger)row{
    static NSString *identifier = @"nameCell";
    LMSellerClassifyTopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LMSellerClassifyTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    if(!showDownView){
        cell = [self topTextCell];
    }else{
        cell = [self topClassifySellerNameCell:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    ShopUnionClassifyEntity *entity = [listArr objectAtIndex:row];
    selectName = entity.industryName;
    
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setObject:entity.industryName forKey:@"industryName"];
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notfication_Name_SellerClassifyBtnClicked object:entity.industryName];
}

#pragma mark 
-(void)arrowBtnClicked{
    if(!showDownView){
        showDownView = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notfication_Name_SellerClassifyDropListClose object:nil];
        [UIView animateWithDuration:0.3 animations:^{
            [arrowBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
        }];
    }else{
        showDownView = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notfication_Name_SellerClassifyDropListOpen object:nil];
        [UIView animateWithDuration:0.3 animations:^{
            [arrowBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
        }];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    if(showDownView){
        WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
        NSInteger count = 0;
        for(ShopUnionClassifyEntity *entity in listArr){
            if([entity.industryName isEqualToString:[userDefault textValueForKey:@"industryName"]]){
                break;
            }
            count ++;
        }
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

-(void)maskViewClicked{
    [self arrowBtnClicked];
}

-(void)changeSellerName:(id)entity{
    [self arrowBtnClicked];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notfication_Name_SellerClassifyBtnClicked object:entity];
}

-(void)initClassifySellerArr:(NSArray *)classifyArr{
    listArr = classifyArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    //下拉区域列表
    showDownView = YES;
    sellerDropListView = [self createSellerDropListViewWith:arrowBtn];
    [sellerDropListView unshow:NO];
    [self addSubview:sellerDropListView];
    
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    NSInteger count = 0;
    for(ShopUnionClassifyEntity *entity in listArr){
        if([entity.industryName isEqualToString:[userDefault textValueForKey:@"industryName"]]){
            break;
        }
        count ++;
    }
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
