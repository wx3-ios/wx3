//
//  PersonalInfoOrderListCell.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonalInfoOrderListCell.h"
#import "UserInfoDef.h"

@implementation PersonalInfoOrderListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 25;
        CGFloat labelWidth = 100;
        CGFloat labelHeight = 15;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(self.bounds.size.width-xOffset-labelWidth, (CommonCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setText:@"查看全部订单"];
        [label setTextColor:WXColorWithInteger(0xbbbbbb)];
        [label setFont:WXFont(13.0)];
        [self.contentView addSubview:label];
    }
    return self;
}

-(void)load{
    
}

@end
