//
//  ClassifyListVC.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyListVC.h"
#import "ClassifyLeftListView.h"
#import "ClassifyRightListView.h"
#import "WXTUITextField.h"
#import "ClassifySearchVC.h"
#import "ClassifyModel.h"
#import "ClassifyGoodsListVC.h"
#import "NewGoodsInfoVC.h"

#define size self.bounds.size
#define yGap (10)
#define TextFieldHeight (25)

@interface ClassifyListVC (){
    WXTUITextField *_textField;
    
    ClassifyLeftListView *_leftView;
    ClassifyRightListView *_rightView;
    
    ClassifyModel *_classifyModel;
}

@end

@implementation ClassifyListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"分类"];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self createListViewUI];
    [self createSearchViewUI];
    
    [[ClassifyModel shareClassifyNodel] loadAllClassifyData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(loadClassifyDataSucceed) name:D_Notification_Name_LoadClassifyData_Succeed object:nil];
    [defaultCenter addObserver:self selector:@selector(loadClassifyDataFailed:) name:D_Notification_Name_LoadClassifyData_Failed object:nil];
    [defaultCenter addObserver:self selector:@selector(gotoGoodsListVC:) name:D_Notification_Name_ClassifyGoodsClicked object:nil];
}

-(void)createSearchViewUI{
    CGFloat xOffset = 17;
    _textField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yGap, size.width-2*xOffset, TextFieldHeight)];
    [_textField setEnabled:NO];
    [_textField setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_textField setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_textField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_textField setTintColor:WXColorWithInteger(0xdd2726)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassifySearchImg.png"]];
    [_textField setLeftView:imgView leftGap:10 rightGap:0];
    [_textField setLeftViewMode:UITextFieldViewModeUnlessEditing];
    [_textField setPlaceholder:@"寻找你喜欢的商品、店铺"];
    [_textField setFont:WXFont(12.0)];
    [self addSubview:_textField];
    
    WXUIButton *clearBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = _textField.frame;
    [clearBtn setBackgroundColor:[UIColor clearColor]];
    [clearBtn addTarget:self action:@selector(startInput) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, yGap+TextFieldHeight+yGap-0.5, size.width, 0.5);
    [lineLabel setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineLabel];
}

-(void)createListViewUI{
    CGFloat yOffset = yGap+TextFieldHeight+yGap;
    CGFloat leftViewWidth = ClassifyLeftViewWidth;
    _rightView = [[ClassifyRightListView alloc] init];
    [_rightView.view setFrame:CGRectMake(leftViewWidth, yOffset, size.width-leftViewWidth, size.height-yOffset)];
    [_rightView addNotification];
    
    _leftView = [[ClassifyLeftListView alloc] init];
    [_leftView.view setFrame:CGRectMake(0, yOffset, leftViewWidth, size.height-yOffset)];
    _leftView.cat_id = _cat_id;
    [_leftView.view setHidden:YES];
    [_rightView.view setHidden:YES];
    [self addSubview:_leftView.view];
    [self addSubview:_rightView.view];
}

-(void)loadClassifyDataSucceed{
    [_leftView.view setHidden:NO];
    [_rightView.view setHidden:NO];
    [self unShowWaitView];
}

-(void)loadClassifyDataFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"获取分类数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)startInput{
    ClassifySearchVC *searchVC = [[ClassifySearchVC alloc] init];
    [self.wxNavigationController pushViewController:searchVC];
}

-(void)gotoGoodsListVC:(NSNotification*)notification{
    NSDictionary *catDic = notification.object;
    BOOL isGoods = NO;
    for(NSString *key in [catDic allKeys]){
        if([key isEqualToString:@"goods_id"]){
            isGoods = YES;
        }
    }
    if(isGoods){
        NewGoodsInfoVC *goodsInfoVC = [[NewGoodsInfoVC alloc] init];
        goodsInfoVC.goodsId = [[catDic objectForKey:@"goods_id"] integerValue];
        goodsInfoVC.goodsInfo_type = GoodsInfo_Normal;
        [self.wxNavigationController pushViewController:goodsInfoVC];
    }else{
        ClassifyGoodsListVC *listVC = [[ClassifyGoodsListVC alloc] init];
        listVC.cat_id = [[catDic objectForKey:@"cat_id"] integerValue];
        listVC.titleName = [catDic objectForKey:@"cat_name"];
        [self.wxNavigationController pushViewController:listVC];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_textField.inputView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
