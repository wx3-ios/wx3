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

#define size self.bounds.size
#define yGap (10)
#define TextFieldHeight (25)

@interface ClassifyListVC (){
    WXTUITextField *_textField;
    
    ClassifyLeftListView *_leftView;
    ClassifyRightListView *_rightView;
}

@end

@implementation ClassifyListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    [self createSearchViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"分类"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self createListViewUI];
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoGoodsListVC) name:D_Notification_Name_ClassifyGoodsClicked object:nil];
}

-(void)createSearchViewUI{
    CGFloat xOffset = 17;
    _textField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yGap, size.width-2*xOffset, TextFieldHeight)];
    [_textField setEnabled:NO];
    [_textField setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_textField setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_textField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_textField setTintColor:WXColorWithInteger(0xdd2726)];
    [_textField setPlaceholder:@"🔍寻找你喜欢的商品、店铺"];
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
    [self addSubview:_leftView.view];
    [self addSubview:_rightView.view];
}

-(void)startInput{
    ClassifySearchVC *searchVC = [[ClassifySearchVC alloc] init];
    [self.wxNavigationController pushViewController:searchVC];
}

-(void)gotoGoodsListVC{
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
