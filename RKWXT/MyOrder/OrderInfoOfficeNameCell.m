//
//  OrderInfoOfficeNameCell.m
//  Woxin2.0
//
//  Created by qq on 14-8-23.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "OrderInfoOfficeNameCell.h"
#import "OrderListEntity.h"

@interface OrderInfoOfficeNameCell (){
    WXUILabel *_nameLabel;
}

@end

@implementation OrderInfoOfficeNameCell

-(void)dealloc{
    RELEASE_SAFELY(_nameLabel);
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 12;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = 15;
        WXUIImageView *imgView = [[[WXUIImageView alloc] init] autorelease];
        imgView.frame = CGRectMake(xOffset, (OrderInfoOfficeNameCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"officeSign.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+12;
        CGFloat nameWidth = 130;
        CGFloat nameHeight = 30;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, (OrderInfoOfficeNameCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x969696)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

-(void)load{
    OrderListEntity *orderEntity = self.cellInfo;
    [_nameLabel setText:orderEntity.shop_name];
}

@end
