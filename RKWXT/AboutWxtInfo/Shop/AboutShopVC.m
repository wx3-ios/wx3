//
//  AboutShopVC.m
//  RKWXT
//
//  Created by SHB on 15/7/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AboutShopVC.h"
#import "WXRemotionImgBtn.h"
#import "PictureBrowseView.h"
#import "AbouShopDef.h"
#import "AboutShopEntity.h"
#import "AboutShopModel.h"
#import "NSString+HTML.h"

#define ShopInfoHeadImgHeight (214)

@interface AboutShopVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *shopInfoArr;
}
@end

@implementation AboutShopVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:kMerchantName];
    [self loadtableView];
    
    [self addOBS];
    [[AboutShopModel shareShopModel] loadShopInfo];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)loadtableView{
    _tableView = [[WXUITableView alloc] initWithFrame:self.bounds];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadShopInfoSucceed) name:K_Notification_Name_LoadShopInfoSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadShopInfoFailed:) name:K_Notification_Name_LoadShopInfoFailed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return AboutShop_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case AboutShop_Section_Head:
            row = ShopHead_Row_Invalid;
            break;
        case AboutShop_Section_TwoDimension:
        case AboutShop_Section_ShopInfo:
            row = 1;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case AboutShop_Section_Head:
        {
            if(indexPath.row == ShopHead_Row_Img){
                height = ShopInfoHeadImgHeight;
            }else{
                AboutShopEntity *entity = nil;
                if([shopInfoArr count] > 0){
                    entity = [shopInfoArr objectAtIndex:0];
                    NSString *newStr = [entity.seller_desc stringByConvertingHTMLToPlainText];
                    height = [newStr stringHeight:[UIFont systemFontOfSize:14.0] width:IPHONE_SCREEN_WIDTH-16]+15;
                }
            }
        }
            break;
        case AboutShop_Section_TwoDimension:
            height = TwoDimensionCellHeight;
            break;
        case AboutShop_Section_ShopInfo:
        {
            AboutShopEntity *entity = nil;
            if([shopInfoArr count] > 0){
                NSString *address = [NSString stringWithFormat:@"分店地址:   %@",entity.address];
                CGFloat height1 = [address stringHeight:[UIFont systemFontOfSize:14.0] width:IPHONE_SCREEN_WIDTH-16];
                height = height1+55;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section == AboutShop_Section_Head){
        height = 0;
    }else{
        height = 10;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case AboutShop_Section_Head:
        {
            if(row == ShopHead_Row_Img){
                cell = [self headImgCellAtRow:row];
            }else{
                cell = [self aboutShopInfoDescAtRow:row];
            }
        }
            break;
        case AboutShop_Section_TwoDimension:
            cell = [self twoDimensionCellAtRow:row];
            break;
        case AboutShop_Section_ShopInfo:
            cell = [self aboutShopInfoAtSection];
            break;
        default:
            break;
    }
    return cell;
}

//关于商家顶部图片
-(WXUITableViewCell *)headImgCellAtRow:(NSInteger)row{
    static NSString *identifier = @"headImg";
    AboutShopTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AboutShopTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
    AboutShopEntity *entity = [shopInfoArr objectAtIndex:0];
    for(NSString *url in entity.imgArr){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, ShopInfoHeadImgHeight)];
        [imgView setCpxViewInfo:url];
        [merchantImgViewArray addObject:imgView];
    }
    cell = [[AboutShopTopImgCell alloc] initWithReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell load];
    return cell;
}

//关于商家顶部描述
-(AboutShopInfoCell *)aboutShopInfoDescAtRow:(NSInteger)row{
    static NSString *identifier = @"descriptionCell";
    AboutShopInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AboutShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setUserInteractionEnabled:NO];
    if([shopInfoArr count] > 0){
        AboutShopEntity *entity = [shopInfoArr objectAtIndex:0];
        [cell loadAboutShopInfoDescription:entity.seller_desc];
    }
    return cell;
}

//所有分店列表
-(AboutShopInfoCell *)aboutShopInfoAtSection{
    static NSString *identifier = @"shopInfoCell";
    AboutShopInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AboutShopInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setUserInteractionEnabled:NO];
    if([shopInfoArr count] > 0){
        [cell setCellInfo:[shopInfoArr objectAtIndex:0]];
    }
    [cell load];
    return cell;
}

//商家二维码
-(WXUITableViewCell *)twoDimensionCellAtRow:(NSInteger)row{
    static NSString *identifier = @"twoDimensionCell";
    ShopTwoDimensionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopTwoDimensionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)showDBarcodeFromThumbView:(UIView*)thumbDBarcode{
    PictureBrowseView *pictureBrowse = [[PictureBrowseView alloc] init];
    [pictureBrowse showthumbView:thumbDBarcode toDestView:self.view withImage:[UIImage imageNamed:@"TwoDimension.png"] animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == AboutShop_Section_TwoDimension){
        ShopTwoDimensionCell *cell = (ShopTwoDimensionCell*)[tableView cellForRowAtIndexPath:indexPath];
        [self showDBarcodeFromThumbView:cell.thumbView];
    }
}

//notification
-(void)loadShopInfoSucceed{
    [self unShowWaitView];
    shopInfoArr = [AboutShopModel shareShopModel].shopInfoArr;
    [_tableView reloadData];
}

-(void)loadShopInfoFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"获取商家信息失败";
    }
    [UtilTool showAlertView:message];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
