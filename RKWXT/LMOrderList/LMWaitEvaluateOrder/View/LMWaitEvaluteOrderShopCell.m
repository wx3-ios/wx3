//
//  LMWaitEvaluteOrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMWaitEvaluteOrderShopCell.h"
#import "LMOrderListEntity.h"

@interface LMWaitEvaluteOrderShopCell(){
    WXUILabel *nameLabel;
    WXUIImageView *arrowImgView;
    WXUILabel *stateLabel;
}
@end

@implementation LMWaitEvaluteOrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (LMWaitEvaluteOrderShopCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"LMSellerIcon.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelheight = 20;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMWaitEvaluteOrderShopCellHeight-nameLabelheight)/2, nameLabelWidth, nameLabelheight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameLabelWidth+10;
        CGFloat width = 8;
        CGFloat height = 12;
        arrowImgView = [[WXUIImageView alloc] init];
        arrowImgView.frame = CGRectMake(xOffset, (LMWaitEvaluteOrderShopCellHeight-height)/2, width, height);
        [arrowImgView setBackgroundColor:[UIColor clearColor]];
        [arrowImgView setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:arrowImgView];
        
        CGFloat stateLabelWidth = 100;
        CGFloat statelabelHeight = 20;
        stateLabel = [[WXUILabel alloc] init];
        stateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-stateLabelWidth, (LMWaitEvaluteOrderShopCellHeight-statelabelHeight)/2, stateLabelWidth, statelabelHeight);
        [stateLabel setBackgroundColor:[UIColor clearColor]];
        [stateLabel setTextAlignment:NSTextAlignmentRight];
        [stateLabel setFont:WXFont(10.0)];
        [stateLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:stateLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    
    [nameLabel setText:entity.shopName];
    
    CGRect rect = nameLabel.frame;
    rect.size.width = [NSString widthForString:entity.shopName fontSize:15.0 andHeight:20];
    [nameLabel setFrame:rect];
    
    CGRect rect1 = arrowImgView.frame;
    rect1.origin.x = rect.size.width+rect.origin.x+10;
    [arrowImgView setFrame:rect1];
    
    [stateLabel setText:[self orderState:entity]];
}

-(NSString*)orderState:(LMOrderListEntity*)entity{
    NSString *orderState = nil;
    if(entity.orderState == LMorder_State_Complete){
        return @"订单已完成";
    }
    return orderState;
}

@end
