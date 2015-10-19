//
//  ClassifyRightCell.h
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyDownCell.h"
#import "ClassifyLeftTableViewCell.h"

@protocol ClassifyRightCellDelegate;
@interface ClassifyRightCell : ClassifyDownCell
@property (nonatomic,assign)id<ClassifyRightCellDelegate>delegate;
@end

@protocol ClassifyRightCellDelegate <NSObject>
-(void)goodsListCellClicked:(id)entity;

@end
