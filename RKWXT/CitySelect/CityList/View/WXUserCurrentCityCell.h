//
//  WXUserCurrentCityCell.h
//  RKWXT
//
//  Created by SHB on 15/11/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol WXUserCurrentCityCellDelegate;

@interface WXUserCurrentCityCell : WXUITableViewCell
@property (nonatomic,assign) id<WXUserCurrentCityCellDelegate>delegate;
@end

@protocol WXUserCurrentCityCellDelegate <NSObject>
-(void)userCurrentCityCellBtnClicked:(NSInteger)count;

@end
