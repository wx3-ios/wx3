//
//  WXTFindCommmonCell.h
//  RKWXT
//
//  Created by SHB on 15/4/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

typedef enum{
    FinCommon_Type_One = 1,
    FinCommon_Type_Two,
    FinCommon_Type_Three,
}FinCommon_Type;

#define FindCommonCellHeight (85)

@protocol WXTFindCommmonCellDelegate;

@interface WXTFindCommmonCell : WXUITableViewCell
@property (nonatomic,assign) id<WXTFindCommmonCellDelegate>delegate;
@end

@protocol WXTFindCommmonCellDelegate <NSObject>
-(void)wxtFindCommonCellClicked:(FinCommon_Type)type;

@end
