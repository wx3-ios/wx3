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

#define Size self.bounds.size

@interface LMSellerInfoVC ()<UITableViewDataSource,UITableViewDelegate,LMSellerInfoDesCellDelegate>{
    UITableView *_tableView;
    NSArray *shopArr;
}

@end

@implementation LMSellerInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"商家详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [shopArr count]+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    return 3;
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

-(WXUITableViewCell*)lmSellerInfoTopImgCell{
    static NSString *identifier = @"topImgCell";
    LMSellerInfoTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSellerInfoTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    [cell load];
    return cell;
}

-(WXUITableViewCell*)lmMoreSellerListCell:(NSInteger)section{
    static NSString *identifier = @"sellerListCell";
    LMMoreSellerListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMMoreSellerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
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

#pragma mark callBtnDelegate
-(void)lmShopInfoDesCallBtnClicked:(NSString *)sellerPhone{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
