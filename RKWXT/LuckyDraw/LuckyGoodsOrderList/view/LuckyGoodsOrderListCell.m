//
//  LuckyGoodsOrderListCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsOrderListCell.h"

@interface LuckyGoodsOrderListCell(){
    WXUIImageView *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_deslabel;
    WXUILabel *_dateLabel;
    WXUILabel *_typeLabel;
}
@end

@implementation LuckyGoodsOrderListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 41;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXUIImageView alloc] init];
        _imgView.frame = CGRectMake(xOffset, (LuckyGoodsOrderListCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [_imgView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+1;
        CGFloat yOffset = 12;
        CGFloat dateLabelWidth = 65;
        CGFloat nameLabelWidth = IPHONE_SCREEN_WIDTH-xOffset-dateLabelWidth-10;
        CGFloat namelabelHeight = 20;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += namelabelHeight+10;
        CGFloat desLabelHeight = 17;
        _deslabel = [[WXUILabel alloc] init];
        _deslabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, desLabelHeight);
        [_deslabel setBackgroundColor:[UIColor clearColor]];
        [_deslabel setTextAlignment:NSTextAlignmentLeft];
        [_deslabel setTextColor:WXColorWithInteger(0x8e8e8e)];
        [_deslabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_deslabel];
        
        CGFloat xGap = 12;
        CGFloat yGap = 12;
        CGFloat dateLabelHeight = 15;
        _dateLabel = [[WXUILabel alloc] init];
        _dateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-dateLabelWidth, yGap, dateLabelWidth, dateLabelHeight);
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setFont:WXFont(10.0)];
        [_dateLabel setTextColor:WXColorWithInteger(0x8e8e8e)];
        [self.contentView addSubview:_dateLabel];
        
        yGap += dateLabelHeight+15;
        _typeLabel = [[WXUILabel alloc] init];
        _typeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-dateLabelWidth, yGap, dateLabelWidth, dateLabelHeight);
        [_typeLabel setBackgroundColor:[UIColor clearColor]];
        [_typeLabel setTextAlignment:NSTextAlignmentRight];
        [_typeLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_typeLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_typeLabel];
    }
    return self;
}

-(void)load{
    [_imgView setImage:[UIImage imageNamed:@"Icon.png"]];
    [_nameLabel setText:@"我信科技有限公司"];
    [_deslabel setText:@"科技型"];
    [_dateLabel setText:@"2015-08-17"];
    [_typeLabel setText:@"未支付"];
}

@end
