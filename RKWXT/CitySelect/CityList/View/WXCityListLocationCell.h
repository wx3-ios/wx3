//
//  WXCityListLocationCell.h
//  RKWXT
//
//  Created by SHB on 15/11/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol WXCityListLocationCellDelegate;

@interface WXCityListLocationCell : WXUITableViewCell
@property (nonatomic,assign) id<WXCityListLocationCellDelegate>delegate;
@end

@protocol WXCityListLocationCellDelegate <NSObject>
-(void)wxCityListLocationCellBtnCLicked;

@end
