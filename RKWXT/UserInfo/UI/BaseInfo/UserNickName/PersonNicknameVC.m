//
//  PersonNicknameVC.m
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonNicknameVC.h"

@interface PersonNicknameVC(){
    WXUITextField *nickName;
}
@end

@implementation PersonNicknameVC
@synthesize delegate = _delegate;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"昵称"];
    
    CGFloat yOffset = 10;
    CGFloat height = 30;
    nickName = [[WXUITextField alloc] init];
    nickName.frame = CGRectMake(2, yOffset, self.bounds.size.width-4, height);
    [nickName setBackgroundColor:[UIColor whiteColor]];
    [nickName setBorderRadian:2.0 width:0.1 color:[UIColor grayColor]];
    [nickName setPlaceholder:@"请设置昵称"];
    [nickName setTextAlignment:NSTextAlignmentCenter];
    [nickName setFont:WXFont(14.0)];
    [nickName addTarget:self action:@selector(personNickname) forControlEvents:UIControlEventEditingDidEnd];
    [self addSubview:nickName];
}

-(void)personNickname{
    if(nickName.text.length != 0){
        if(_delegate && [_delegate respondsToSelector:@selector(didSetPersonNickname:)]){
            [_delegate didSetPersonNickname:nickName.text];
        }
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
