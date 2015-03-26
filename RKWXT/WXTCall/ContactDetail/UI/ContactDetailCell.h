//
//  ContactDetailCell.h
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

#define ContactDetailCellHeight (45)

@protocol ContactDetailDelegate;
@interface ContactDetailCell : WXTUITableViewCell
@property (nonatomic,assign) id<ContactDetailDelegate>delegate;
@end

@protocol ContactDetailDelegate <NSObject>
-(void)callContactWithPhone:(NSString*)phoneNumber;

@end
