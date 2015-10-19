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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"分类"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self createSearchViewUI];
    [self createListViewUI];
}

-(void)createSearchViewUI{
    CGFloat xOffset = 17;
    _textField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yGap, size.width-2*xOffset, TextFieldHeight)];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [_textField setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_textField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_textField setTintColor:WXColorWithInteger(0xdd2726)];
    [_textField setLeftViewMode:UITextFieldViewModeAlways];
    [_textField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textField setPlaceholder:@"🔍寻找你喜欢的商品、店铺"];
    [self addSubview:_textField];
    
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

-(void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
