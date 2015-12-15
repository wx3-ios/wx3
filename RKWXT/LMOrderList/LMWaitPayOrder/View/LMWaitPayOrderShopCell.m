//
//  LMWaitPayOrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMWaitPayOrderShopCell.h"

@interface LMWaitPayOrderShopCell(){
    WXUILabel *nameLabel;
    WXUIImageView *arrowImgView;
    WXUILabel *stateLabel;
}
@end

@implementation LMWaitPayOrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (LMWaitPayOrderShopCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"LMSellerIcon.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelheight = 20;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMWaitPayOrderShopCellHeight-nameLabelheight)/2, nameLabelWidth, nameLabelheight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameLabelWidth+10;
        CGFloat width = 8;
        CGFloat height = 12;
        arrowImgView = [[WXUIImageView alloc] init];
        arrowImgView.frame = CGRectMake(xOffset, (LMWaitPayOrderShopCellHeight-height)/2, width, height);
        [arrowImgView setBackgroundColor:[UIColor clearColor]];
        [arrowImgView setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:arrowImgView];
        
        CGFloat stateLabelWidth = 100;
        CGFloat statelabelHeight = 20;
        stateLabel = [[WXUILabel alloc] init];
        stateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-stateLabelWidth, (LMWaitPayOrderShopCellHeight-statelabelHeight)/2, stateLabelWidth, statelabelHeight);
        [stateLabel setBackgroundColor:[UIColor clearColor]];
        [stateLabel setTextAlignment:NSTextAlignmentRight];
        [stateLabel setFont:WXFont(10.0)];
        [stateLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:stateLabel];
    }
    return self;
}

-(void)load{
    NSString *name = self.cellInfo;
    [nameLabel setText:@"测试数据"];
    
    CGRect rect = nameLabel.frame;
    rect.size.width = [[self class] widthForString:name fontSize:15.0 andHeight:20];
    [nameLabel setFrame:rect];
    
    CGRect rect1 = arrowImgView.frame;
    rect1.origin.x = rect.size.width+rect.origin.x+10;
    [arrowImgView setFrame:rect1];
}


+(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

@end
