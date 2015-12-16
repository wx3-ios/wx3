//
//  LMOrderInfoOrderStateCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoOrderStateCell.h"

@interface LMOrderInfoOrderStateCell(){
    WXUILabel *nameLabel;
}
@end

@implementation LMOrderInfoOrderStateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 16;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (LMOrderInfoOrderStateCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"OrderInfoState.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth;
        CGFloat labelWidth = 56;
        CGFloat labelHeight = 16;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (LMOrderInfoOrderStateCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x000000)];
        [textLabel setText:@"订单状态"];
        [textLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:textLabel];
        
        xOffset += labelWidth;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMOrderInfoOrderStateCellHeight-labelHeight)/2, 150, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:WXFont(13.0)];
        [nameLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    
}

@end
