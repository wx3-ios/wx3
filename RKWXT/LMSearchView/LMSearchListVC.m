//
//  LMSearchListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/9.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchListVC.h"
#import "LMHotSearchListCell.h"

#define Size self.bounds.size

@interface LMSearchListVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    WXUITextField *_textField;
    UITableView *_tableView;
    
    BOOL showHistory;
    
    NSArray *hotSearchArr;  //热门搜索
    NSArray *searchHistoryArr; //搜索历史
    NSArray *searchListArr;  //搜索记录
}

@end

@implementation LMSearchListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:WXColorWithInteger(0xffffff)];
    showHistory = YES;
    
    [self createNavigationBar];
    [self createSearchView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 66, Size.width, Size.height-66);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
}

-(void)createNavigationBar{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 66);
    [imgView setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:imgView];
    
    CGFloat xOffset = 15;
    CGFloat yOffset = 40;
    UIImage *img = [UIImage imageNamed:@"T_BackWhite.png"];
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, img.size.width, img.size.height);
    [backBtn setImage:img forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
}

-(void)createSearchView{
    CGFloat width = 3*Size.width/4;
    CGFloat height = 25;
    _textField = [[WXUITextField alloc] initWithFrame:CGRectMake((Size.width-width)/2, 66-height-10, width, height)];
    [_textField setDelegate:self];
    [_textField setReturnKeyType:UIReturnKeySearch];
    [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(changeInput) forControlEvents:UIControlEventEditingChanged];
    [_textField setFont:WXFont(13.0)];
    [_textField becomeFirstResponder];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_textField setTextColor:[UIColor whiteColor]];
    [_textField setTintColor:[UIColor whiteColor]];
    [_textField setPlaceHolder:@"搜索" color:WXColorWithInteger(0xffffff)];
    [self addSubview:_textField];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if(showHistory){
        section = 2;
    }else{
        section = 1;
    }
    return section;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(showHistory){
        if(section == 0){
            return ([hotSearchArr count]>0?1:0)+1;
        }else{
            return [searchHistoryArr count]+1;
        }
    }else{
        return [searchListArr count]+1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(showHistory){
        if(section == 0){
            if(row == 0){
                height = 20;
            }else{
                height = [LMHotSearchListCell cellHeightOfInfo:hotSearchArr];
            }
        }else{
            if(row == 0){
                height = 20;
            }else{
                height = 44;
            }
        }
    }else{
        if(row == 0){
            height = 20;
        }else{
            height = 44;
        }
    }
    return height;
}

-(WXUITableViewCell*)hotSearchListTitleCell{
    static NSString *identifier = @"hotSearchListTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.textLabel setText:@"热门搜索"];
    return cell;
}

-(WXUITableViewCell*)hotSearchListCell{
    static NSString *identifier = @"hotSearchListCell";
    LMHotSearchListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMHotSearchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:hotSearchArr];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)searchHistoryListCell:(NSInteger)row{
    static NSString *identifier = @"historyListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == 0){
        [cell.textLabel setText:@"搜索历史"];
    }
    if(row > 0){
        
    }
    return cell;
}

//搜索记录
-(WXUITableViewCell*)searchResultListCell:(NSInteger)row{
    static NSString *identifier = @"resultListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == 0){
        [cell.textLabel setText:@"搜索结果"];
    }
    if(row > 0){
        
    }
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(showHistory){
        if(section == 0){
            if(row == 0){
                cell = [self hotSearchListTitleCell];
            }else{
                cell = [self hotSearchListCell];
            }
        }else{
            cell = [self searchHistoryListCell:row];
        }
    }else{
        cell = [self searchResultListCell:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark textfield Deleagte
-(void)changeInput{
    showHistory = NO;
}

-(void)textFieldDone:(id)sender{
    [_textField resignFirstResponder];
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
