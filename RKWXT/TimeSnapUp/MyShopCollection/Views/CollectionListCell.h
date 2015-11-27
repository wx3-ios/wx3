//
//  CollectionListCell.h
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeShopData,MerchantID;
@interface CollectionListCell : UITableViewCell
@property (nonatomic,strong)MerchantID *chartID;
+ (instancetype)collectionCreatCell:(UITableView*)tableview;
+ (CGFloat)cellHeight;
@end
