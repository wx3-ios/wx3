//
//  NewRightHeadCell.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewRightHeadCell.h"
#import "WXRemotionImgBtn.h"
#import "GoodsInfoEntity.h"

@interface NewRightHeadCell(){
    WXRemotionImgBtn *_imgView;
    UILabel *_moneylabel;
}
@end

@implementation NewRightHeadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat yOffset = 15;
        CGFloat imgWidth = 70;
        CGFloat imgHeight = 70;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+13;
        yOffset += 22;
        CGFloat labelWidth = 70;
        CGFloat labelHeight = 16;
        _moneylabel = [[UILabel alloc] init];
        _moneylabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [_moneylabel setBackgroundColor:[UIColor clearColor]];
        [_moneylabel setTextAlignment:NSTextAlignmentLeft];
        [_moneylabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_moneylabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_moneylabel];
        
        yOffset += labelHeight+8;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:[UIColor grayColor]];
        [textLabel setFont:WXFont(12.0)];
        [textLabel setText:@"请选择属性"];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.smallImg];
    [_imgView load];
    [_moneylabel setText:[NSString stringWithFormat:@"￥%.2f",entity.shop_price]];
}

@end
