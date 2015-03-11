//
//  RecentCell.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-8.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentData.h"

@interface RecentCell : UITableViewCell


@property (nonatomic, assign) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) IBOutlet UILabel *groupLabel;
@property (nonatomic, assign) IBOutlet UILabel *phoneLabel;
@property (nonatomic, assign) IBOutlet UILabel *areaLabel;
@property (nonatomic, assign) IBOutlet UILabel *timeLabel;

@property (nonatomic, assign) IBOutlet NSLayoutConstraint *gapConstraint;

@property (nonatomic, strong) RecentData *recent;

@end
