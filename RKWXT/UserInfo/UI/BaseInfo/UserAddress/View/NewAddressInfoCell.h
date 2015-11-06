//
//  NewAddressInfoCell.h
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define NewAddressInfoCellHeight (68)
@protocol NewAddressInfoCellDelegate;
@interface NewAddressInfoCell : WXUITableViewCell
@property (nonatomic,assign)id<NewAddressInfoCellDelegate>delegate;
@end

@protocol NewAddressInfoCellDelegate <NSObject>
@optional
- (void)textViewValueDidChanged:(NSString*)text;

@end
