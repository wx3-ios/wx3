//
//  MakeOrderPayStatusCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderPayStatusCell.h"
#import "MakeOrderDef.h"

@implementation MakeOrderPayStatusCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat labelWidth = 120;
        CGFloat labelHeight = 15;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(xOffset, (Order_Section_Height_PayStatus-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:WXColorWithInteger(0x646464)];
        [label setFont:WXFont(14.0)];
        [label setText:@"支付方式"];
        [self.contentView addSubview:label];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, (Order_Section_Height_PayStatus-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setText:@"在线支付"];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{

}

@end
