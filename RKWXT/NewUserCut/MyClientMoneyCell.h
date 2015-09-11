//
//  MyClientMoneyCell.h
//  RKWXT
//
//  Created by SHB on 15/9/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define MyClientMoneyCellHeight (82)

@interface MyClientMoneyCell : WXUITableViewCell
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userIcon;
@property (nonatomic,strong) NSString *clientID;

@end
