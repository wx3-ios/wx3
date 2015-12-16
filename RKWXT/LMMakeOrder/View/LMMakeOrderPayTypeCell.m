//
//  LMMakeOrderPayTypeCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderPayTypeCell.h"
#import "LMMakeOrderDef.h"

@implementation LMMakeOrderPayTypeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat labelWidth = 120;
        CGFloat labelHeight = 15;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(xOffset, (LMMakeOrderPayTypeCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:WXColorWithInteger(0xc2c33e)];
        [label setFont:WXFont(15.0)];
        [label setText:@"支付方式"];
        [self.contentView addSubview:label];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, (LMMakeOrderPayTypeCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setText:@"在线支付"];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setTextColor:WXColorWithInteger(0xc2c33e)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    
}

@end
