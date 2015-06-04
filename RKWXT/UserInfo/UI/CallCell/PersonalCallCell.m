//
//  PersonalCallCell.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonalCallCell.h"

@interface PersonalCallCell(){
    UILabel *_money;
}
@end

@implementation PersonalCallCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 100;
        CGFloat moneyWidth = 100;
        CGFloat commonLabelHeight = 18;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(xOffset, (44-commonLabelHeight)/2, moneyWidth, commonLabelHeight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setTextColor:WXColorWithInteger(0xbbbbbb)];
        [_money setFont:WXFont(13.0)];
        [self.contentView addSubview:_money];
        
        CGFloat xGap = 25;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(self.bounds.size.width-xGap-moneyWidth, (44-commonLabelHeight)/2, moneyWidth, commonLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setTextColor:WXColorWithInteger(0xbbbbbb)];
        [nameLabel setFont:WXFont(13.0)];
        [nameLabel setText:@"充值送话费"];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    [_money setText:@"30.0元"];
}

@end
