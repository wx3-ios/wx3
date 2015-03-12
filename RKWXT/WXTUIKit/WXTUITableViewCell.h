//
//  WXTUITableViewCell.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    WXT_CellDefaultAccessoryType_HasNext,   //有下一级页面
    WXT_CellDefaultAccessoryType_Switch,    //带有switch开关
    WXT_CellDefaultAccessoryType_Detail,    //带有详情
    
    WXT_CellDefaultAccessoryType_None,
}WXT_CellDefaultAccessoryType;

@protocol WXTUITableViewCellMark <NSObject>
@optional
//虚函数
-(void)load;
-(void)unload;

@end

@protocol WXTUItableViewCellDelegate;
@interface WXTUITableViewCell : UITableViewCell<WXTUITableViewCellMark>
@property (nonatomic,weak) id<WXTUItableViewCellDelegate>baseDelegate;
@property (nonatomic,strong) id cellInfo;

-(void)setDefaultAccessoryView:(WXT_CellDefaultAccessoryType)type;

+(CGFloat)cellHeightOfInfo:(id)cellInfo;
@end

@protocol WXTUItableViewCellDelegate <NSObject>
@optional
-(void)switchValueChanged:(id)sender;
-(void)toDetail:(id)sender;
-(void)clickButtonToDetail:(id)sender;

@end
