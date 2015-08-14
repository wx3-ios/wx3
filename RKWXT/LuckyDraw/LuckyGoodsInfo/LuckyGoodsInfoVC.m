//
//  LuckyGoodsInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/8/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsInfoVC.h"
#import "LuckyGoodsInfoTopImgCell.h"
#import "LuckyGoodsDesCell.h"
#import "NewGoodsInfoBDCell.h"
#import "NewGoodsInfoDownCell.h"
#import "WXTMallListWebVC.h"

#define size self.bounds.size
#define TopNavigationViewHeight (64)
#define DownViewHeight (50)

enum{
    LuckyGoodsInfo_Section_TopImg = 0,
    LuckyGoodsInfo_Section_TopInfo,
    LuckyGoodsInfo_Section_WebShow,
    LuckyGoodsInfo_Section_GoodsInfo,
    
    LuckyGoodsInfo_Section_Invalid,
};

@interface LuckyGoodsInfoVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    BOOL _isOpen;
}
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation LuckyGoodsInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height-DownViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    
    [self crateTopNavigationView];
}

-(void)crateTopNavigationView{
    WXUIView *topView = [[WXUIView alloc] init];
    topView.frame = CGRectMake(0, 0, size.width, TopNavigationViewHeight);
    [topView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:topView];
    
    CGFloat xGap = 10;
    CGFloat yGap = 10;
    WXUIImageView *topImgView = [[WXUIImageView alloc] init];
    topImgView.frame = topView.frame;
    [topImgView setImage:[UIImage imageNamed:@""]];
    [topView addSubview:topImgView];
    
    CGFloat btnWidth = 25;
    CGFloat btnHeight = 25;
    WXUIButton *backBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xGap, TopNavigationViewHeight-yGap-btnHeight, btnWidth, btnHeight);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    CGFloat labelWidth = 80;
    CGFloat labelHeight = 30;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((size.width-labelWidth)/2, TopNavigationViewHeight-yGap-labelHeight, labelWidth, labelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:WXFont(15.0)];
    [titleLabel setTextColor:WXColorWithInteger(0x000000)];
    [topView addSubview:titleLabel];

    WXUIButton *sharebtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame = CGRectMake(size.width-xGap-btnWidth, TopNavigationViewHeight-yGap-btnHeight, btnWidth, btnHeight);
    [sharebtn setBackgroundColor:[UIColor clearColor]];
    [sharebtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [sharebtn addTarget:self action:@selector(sharebtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sharebtn];
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
    return LuckyGoodsInfo_Section_TopInfo;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case LuckyGoodsInfo_Section_TopImg:
        case LuckyGoodsInfo_Section_TopInfo:
        case LuckyGoodsInfo_Section_WebShow:
            row = 1;
            break;
        case LuckyGoodsInfo_Section_GoodsInfo:
        {
            if(_isOpen){
                if(_selectedIndexPath.section == section){
//                    if([_model.data count] > 0){
//                        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
//                        return [entity.customNameArr count]+1;
//                    }else{
//                        return 1;
//                    }
                }
            }else{
                return 1;
            }
        }
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
        case LuckyGoodsInfo_Section_TopImg:
            height = size.width;
            break;
        case LuckyGoodsInfo_Section_TopInfo:
            height = LuckyGoodsDesCellHeight;
            break;
        case LuckyGoodsInfo_Section_WebShow:
            height = 44;
            break;
        case LuckyGoodsInfo_Section_GoodsInfo:
        {
            if(indexPath.row == 0){
                height = 44;
            }else{
                height = [NewGoodsInfoDownCell cellHeightOfInfo:nil];
            }
        }
            break;
        default:
            break;
    }
    return height;
}

//顶部大图
-(WXUITableViewCell*)tableViewForTopImgCell{
    static NSString *identifier = @"headImg";
    LuckyGoodsInfoTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsInfoTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
//    GoodsInfoEntity *entity = nil;
//    if([_model.data count] > 0){
//        entity = [_model.data objectAtIndex:0];
//    }
//    for(int i = 0; i< [entity.imgArr count]; i++){
//        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, T_GoodsInfoTopImgHeight)];
//        [imgView setExclusiveTouch:NO];
//        [imgView setCpxViewInfo:[entity.imgArr objectAtIndex:i]];
//        [merchantImgViewArray addObject:imgView];
//    }
    cell = [[LuckyGoodsInfoTopImgCell alloc] initWithLuckyReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForLuckyGoodsDesCell{
    static NSString *identifier = @"luckyGoodsCell";
    LuckyGoodsDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//图文详情
-(WXUITableViewCell*)tableViewWebShowCell{
    static NSString *identifier = @"webShowCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsInfo.png"]];
    [cell.textLabel setText:@"图文详情"];
    [cell.textLabel setFont:WXFont(13.0)];
    return cell;
}

//产品参数
-(WXUITableViewCell*)tableViewForBaseDataCell:(NSIndexPath*)indexpath{
    static NSString *identifier = @"baseDateCell";
    NewGoodsInfoBDCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
    [cell.textLabel setText:@"产品参数"];
    [cell changeArrowWithDown:_isOpen];
    [cell.textLabel setFont:WXFont(13.0)];
    return cell;
}

-(WXUITableViewCell*)tabelViewForDownCellAtRow:(NSInteger)row{
    static NSString *identifier = @"textCell";
    NewGoodsInfoDownCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    if([_model.data count] > 0){
//        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
//        //        [cell setCellInfo:[entity.customNameArr objectAtIndex:row]];
//        [cell setName:[entity.customNameArr objectAtIndex:row-1]];
//        [cell setInfo:[entity.customInfoArr objectAtIndex:row-1]];
//    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    if(_isOpen && indexPath.section == LuckyGoodsInfo_Section_GoodsInfo){
        static NSString *identifier = @"goodsInfoBDCell";
        NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(indexPath.row > 0){
            cell = (NewGoodsInfoBDCell*)[self tabelViewForDownCellAtRow:indexPath.row];
        }
        if(indexPath.row == 0){
            [cell changeArrowWithDown:_isOpen];
            [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
            [cell.textLabel setText:@"产品参数"];
        }
        return cell;
    }else{
        WXUITableViewCell *cell = nil;
        NSInteger section = indexPath.section;
        switch (section) {
            case LuckyGoodsInfo_Section_TopImg:
                cell = [self tableViewForTopImgCell];
                break;
            case LuckyGoodsInfo_Section_TopInfo:
                cell = [self tableViewForLuckyGoodsDesCell];
                break;
            case LuckyGoodsInfo_Section_WebShow:
                cell = [self tableViewWebShowCell];
                break;
            case LuckyGoodsInfo_Section_GoodsInfo:
                cell = [self tableViewForBaseDataCell:indexPath];
                break;
            default:
                break;
        }
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == LuckyGoodsInfo_Section_WebShow){
        [self gotoWebView];
    }
    if(section == LuckyGoodsInfo_Section_GoodsInfo){
        if(indexPath.row == 0){
            if([indexPath isEqual:_selectedIndexPath]){
                [self didSelectCellRowFirstDo:NO nextDo:NO];
                _selectedIndexPath = nil;
            }else{
                if(!_selectedIndexPath){
                    [self setSelectedIndexPath:indexPath];
                    [self didSelectCellRowFirstDo:YES nextDo:NO];
                }else{
                    [self didSelectCellRowFirstDo:NO nextDo:YES];
                }
            }
        }
    }
}

#pragma mark cell下拉
-(void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    _isOpen = firstDoInsert;
    NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell changeArrowWithDown:firstDoInsert];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:LuckyGoodsInfo_Section_GoodsInfo] withRowAnimation:UITableViewRowAnimationFade];
    if(_isOpen){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:LuckyGoodsInfo_Section_GoodsInfo] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

-(void)gotoWebView{
//    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    WXTMallListWebVC *webViewVC = [[WXTMallListWebVC alloc] init];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_goodsId], @"goods_id",[NSNumber numberWithInteger:kMerchantID], @"sid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", nil];
//    id ret = [webViewVC initWithFeedType:WXT_UrlFeed_Type_NewMall_ImgAndText paramDictionary:dic];
//    NSLog(@"ret = %@",ret);
    [self.wxNavigationController pushViewController:webViewVC];
}

-(void)sharebtnClicked{
    
}

-(void)back{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
