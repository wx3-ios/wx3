//
//  LMSellerInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerInfoVC.h"
#import "LMSellerInfoTopImgCell.h"
#import "LMSellerInfoDesCell.h"
#import "LMMoreSellerActivityCell.h"
#import "LMMoreSellerListCell.h"
#import "LMMoreSellerTitleCell.h"
#import "LMSellerInfoModel.h"
#import "LMSellerInfoEntity.h"

#define Size self.bounds.size

@interface LMSellerInfoVC ()<UITableViewDataSource,UITableViewDelegate,LMSellerInfoDesCellDelegate,LMSellerInfoModelDelegate,LMMoreSellerListCellDelegate>{
    UITableView *_tableView;
    NSArray *shopArr;
    NSArray *infoArr;
    LMSellerInfoModel *_model;
}

@end

@implementation LMSellerInfoVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMSellerInfoModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"商家详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_model loadLMSellerInfoData:_ssid];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [shopArr count]+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        if(row == 0){
            height = IPHONE_SCREEN_WIDTH;
        }else{
            height = LMSellerInfoDesCellHeight;
        }
    }else{
        if(row == 0){
            height = LMMoreSellerTitleCellHeight;
        }
        if(row == 1){
            height = LMMoreSellerListCellHeight;
        }
        if(row == 2){
            height = LMMoreSellerActivityCellHeight;
        }
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section == 0){
        height = 0;
    }else{
        height = 10;
    }
    return height;
}

-(WXUITableViewCell*)lmSellerInfoTopImgCell{
    static NSString *identifier = @"topImgCell";
    LMSellerInfoTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSellerInfoTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([infoArr count] > 0){
        LMSellerInfoEntity *entity = [infoArr objectAtIndex:0];
        [cell setCellInfo:entity.imgUrlArr];
    }
    [cell load];
    return cell;
}

-(WXUITableViewCell*)lmSellerInfoDesCell{
    static NSString *identfier = @"desCell";
    LMSellerInfoDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMSellerInfoDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    if([infoArr count] > 0){
        LMSellerInfoEntity *entity = [infoArr objectAtIndex:0];
        [cell setCellInfo:entity];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)lmMoreSellerTitleCell:(NSInteger)section{
    static NSString *identifier = @"sellerTitleCell";
    LMMoreSellerTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMoreSellerTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([shopArr count] > 0){
        [cell setCellInfo:[shopArr objectAtIndex:section-1]];
    }
    [cell load];
    return cell;
}

-(WXUITableViewCell*)lmMoreSellerListCell:(NSInteger)section{
    static NSString *identifier = @"sellerListCell";
    LMMoreSellerListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMoreSellerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSArray *goodArr = nil;
    if([shopArr count] > 0){
        LMSellerInfoEntity *entity = [shopArr objectAtIndex:section-1];
        goodArr = entity.shopArr;
    }
    
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = 0*3;
    NSInteger count = [goodArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = 0; i < count; i++){
        [rowArray addObject:[goodArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(WXUITableViewCell*)lmMoreSellerAvtivityCell:(NSInteger)section{
    static NSString *identifier = @"activityCell";
    LMMoreSellerActivityCell *cell= [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMoreSellerActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        if(row == 0){
            cell = [self lmSellerInfoTopImgCell];
        }else{
            cell = [self lmSellerInfoDesCell];
        }
    }else{
        if(row == 0){
            cell = [self lmMoreSellerTitleCell:section];
        }
        if(row == 1){
            cell = [self lmMoreSellerListCell:section];
        }
        if(row == 2){
            cell = [self lmMoreSellerAvtivityCell:row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark model
-(void)loadLMSellerInfoDataSucceed{
    [self unShowWaitView];
    infoArr = _model.sellerInfoArr;
    shopArr = _model.shopListArr;
    [_tableView reloadData];
}

-(void)loadLMSellerInfoDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark callBtnDelegate
-(void)lmShopInfoDesCallBtnClicked:(NSString *)sellerPhone{
    
}

-(void)moreSellerListBtnClicked:(id)entity{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
