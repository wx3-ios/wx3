//
//  RecentCell.m
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-8.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "RecentCell.h"
#import "ContactUitl.h"

@implementation RecentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setRecent:(RecentData *)recent
{
    _recent = recent;
    _timeLabel.text = recent.time;
    _areaLabel.text = recent.area;
    
    _groupLabel.text = recent.groupCount > 1 ? [NSString stringWithFormat:@"[%d]", recent.groupCount] : @"";
    
//    ContactData *cd = [[ContactUitl shareInstance] queryContactFromPhone:recent.phone];
//    if (cd.name.length > 0) {
//        _nameLabel.text = cd.name;
//        _phoneLabel.text = recent.phone;
//        _gapConstraint.constant = 5;
//    }
//    else{
//        _nameLabel.text = recent.phone;
//        _phoneLabel.text = @"";
//        _gapConstraint.constant = 0;
//    }
}


@end
