//
//  NewGoodsInfoDesCell.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoDesCell.h"
#import "GoodsInfoDef.h"
#import "GoodsInfoEntity.h"

#import "TimeShopData.h"

#define LabelWidth (110)

@interface NewGoodsInfoDesCell(){
    WXUILabel *_oldPrice;
    WXUILabel *_lineLabel;
    WXUILabel *_newPrice;
    WXUILabel *_descLabel;
    WXUIButton *_attentionBtn;
    //邮费
    WXUILabel *postageLabel;
    //限时购
    WXUIView *limitBuyView;
    WXUILabel *_saveMoneyLabel;
    WXUILabel *_overTime;
}
@end

@implementation NewGoodsInfoDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat yOffset = 8;
        CGFloat oldLabelHeight = 12;
        _oldPrice  = [[WXUILabel alloc] init];
        _oldPrice.frame = CGRectMake(xOffset, yOffset+14+30, LabelWidth, oldLabelHeight);
        [_oldPrice setTextAlignment:NSTextAlignmentLeft];
        [_oldPrice setTextColor:WXColorWithInteger(midTextColor)];
        [_oldPrice setFont:[UIFont systemFontOfSize:18.0]];
        [_oldPrice setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_oldPrice];
        
        xOffset += LabelWidth+5;
        CGFloat textWidth = 42;
        CGFloat newLabelHeight = 14;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, yOffset+14+30, textWidth, newLabelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentRight];
        [textLabel setText:@"市场价:"];
        [textLabel setTextColor:[UIColor grayColor]];
        [textLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:textLabel];
        
        xOffset += textWidth;
        _newPrice = [[WXUILabel alloc] init];
        _newPrice.frame = CGRectMake(xOffset, yOffset+14+30, textWidth+25+10, newLabelHeight);
        [_newPrice setBackgroundColor:[UIColor clearColor]];
        [_newPrice setTextAlignment:NSTextAlignmentLeft];
        [_newPrice setTextColor:WXColorWithInteger(midTextColor)];
        [_newPrice setTextColor:[UIColor grayColor]];
        [_newPrice setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:_newPrice];
        
        postageLabel = [[WXUILabel alloc] init];
        postageLabel.frame = CGRectMake(14, _newPrice.frame.origin.y+_newPrice.frame.size.height+12, textWidth, newLabelHeight);
        [postageLabel setBackgroundColor:[UIColor clearColor]];
        [postageLabel setTextAlignment:NSTextAlignmentLeft];
        [postageLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [postageLabel setText:@"包邮"];
        [postageLabel setFont:WXFont(14.0)];
        [postageLabel setHidden:YES];
        [self.contentView addSubview:postageLabel];
        
        //限时购
        [self createLimitBuyView:postageLabel.frame.origin.y+postageLabel.frame.size.height];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset-textWidth, yOffset+14+30+newLabelHeight/2, 2*textWidth, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:lineLabel];

        
        yOffset += newLabelHeight + 5;
        CGFloat descLabelHeight = 36;
        _descLabel = [[WXUILabel alloc] init];
        _descLabel.frame = CGRectMake(12, yOffset-newLabelHeight-5, IPHONE_SCREEN_WIDTH-2*12-100, descLabelHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setTextColor:WXColorWithInteger(bigTextColor)];
        [_descLabel setFont:[UIFont systemFontOfSize:13]];
        [_descLabel setNumberOfLines:0];
        [self.contentView addSubview:_descLabel];
        
        
        xOffset = IPHONE_SCREEN_WIDTH-62;
        yOffset = 10;
        WXUILabel *line = [[WXUILabel alloc] init];
        line.frame = CGRectMake(xOffset, yOffset, 0.5, T_GoodsInfoDescHeight-2*yOffset);
        [line setBackgroundColor:WXColorWithInteger(0xcacaca)];
//        [self.contentView addSubview:line];
        
        CGFloat btnWidth = 27;
        CGFloat btnHeight = 25;
        _attentionBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset-btnWidth)/2, yOffset+(T_GoodsInfoDescHeight-yOffset-btnHeight-25)/2, btnWidth, btnHeight);
        [_attentionBtn setImage:[UIImage imageNamed:@"T_ShareGoods.png"] forState:UIControlStateNormal];
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:smallTextFont]];
        [_attentionBtn setTitleColor:WXColorWithInteger(smallTextColor) forState:UIControlStateNormal];
//        [_attentionBtn addTarget:self action:@selector(payAttention:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_attentionBtn];
    }
    return self;
}

-(void)createLimitBuyView:(CGFloat)yOffset{
    limitBuyView = [[WXUIView alloc] init];
    limitBuyView.frame = CGRectMake(0, yOffset, IPHONE_SCREEN_WIDTH, 44);
    
    WXUILabel *upLine = [[WXUILabel alloc] init];
    upLine.frame = CGRectMake(0, 0.5, IPHONE_SCREEN_WIDTH, 0.5);
    [upLine setBackgroundColor:[UIColor grayColor]];
    [limitBuyView addSubview:upLine];
    
    CGFloat xOffset = 15;
    CGFloat imgWidth = 80;
    CGFloat imgHeight = 26;
    yOffset += 0.5+(44-imgHeight)/2;
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(xOffset, yOffset, imgWidth, imgHeight);
    [imgView setImage:[UIImage imageNamed:@"LimitGoodsInfoClickBgImg.png"]];
    [limitBuyView addSubview:imgView];
    
    xOffset += 1;
    CGFloat clickImgWidth = 18;
    CGFloat clickImgHeight = clickImgWidth;
    WXUIImageView *clickImg = [[WXUIImageView alloc] init];
    clickImg.frame = CGRectMake(xOffset, yOffset, clickImgWidth, clickImgHeight);
    [clickImg setImage:[UIImage imageNamed:@"LimitGoodsInfoClickImg.png"]];
    [limitBuyView addSubview:clickImg];
    
    CGFloat textLabelWidth = 50;
    CGFloat textLabelHeight = 25;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset+clickImgWidth+5, yOffset, textLabelWidth, textLabelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"限时购"];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:WXFont(14.0)];
    [textLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [limitBuyView addSubview:textLabel];
    
    xOffset = 15+imgWidth+6;
    CGFloat saveLabelWidth = 72;
    CGFloat saveLabelHeight = 25;
    _saveMoneyLabel = [[WXUILabel alloc] init];
    _saveMoneyLabel.frame = CGRectMake(xOffset, (44-saveLabelHeight)/2, saveLabelWidth, saveLabelHeight);
    [_saveMoneyLabel setBackgroundColor:[UIColor clearColor]];
    [_saveMoneyLabel setTextAlignment:NSTextAlignmentCenter];
    [_saveMoneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [_saveMoneyLabel setFont:WXFont(14.0)];
    [limitBuyView addSubview:_saveMoneyLabel];
    
    xOffset += saveLabelWidth;
    _overTime = [[WXUILabel alloc] init];
    _overTime.frame = CGRectMake(xOffset, (44-saveLabelHeight)/2, IPHONE_SCREEN_WIDTH-xOffset, saveLabelHeight);
    [_overTime setBackgroundColor:[UIColor clearColor]];
    [_overTime setTextAlignment:NSTextAlignmentLeft];
    [_overTime setTextColor:WXColorWithInteger(0x969696)];
    [_overTime setFont:WXFont(14.0)];
    [limitBuyView addSubview:_overTime];
    [self.contentView addSubview:limitBuyView];
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [_oldPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.shop_price]];
    [_newPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.market_price]];
    [_descLabel setText:entity.intro];
//    if(entity.concernID != 0){
//        [_attentionBtn setImage:[UIImage imageNamed:@"T_AttentionSel.png"] forState:UIControlStateNormal];
//    }
    
    if(entity.postage == Goods_Postage_None && !_isLucky){
        [postageLabel setHidden:NO];
    }
    
    if(_lEntity){
        [limitBuyView setHidden:NO];
        TimeShopData *limitEntity = _lEntity;
        [_oldPrice setText:[NSString stringWithFormat:@"￥%.2f",[limitEntity.goods_price floatValue]]];
        [_newPrice setText:[NSString stringWithFormat:@"￥%.2f",[limitEntity.scare_buying_price floatValue]]];
        [_overTime setText:[self limitTime:[limitEntity.begin_time integerValue] andEndTime:[limitEntity.end_time integerValue]]];
    }else{
        [limitBuyView setHidden:YES];
    }
}

-(NSString*)limitTime:(NSInteger)startTime andEndTime:(NSInteger)endTime{
    NSString *limitTime = nil;
    NSInteger currentTime = [UtilTool timeChange];
    if(startTime >= currentTime){
        NSInteger hour = (startTime-currentTime)/3600;
        NSInteger minute = (startTime-currentTime)%3600/60;
        NSInteger seconds = (startTime-currentTime)%3600%60/60;
        limitTime = [NSString stringWithFormat:@"还剩下%ld小时%ld分%ld秒",(long)hour,(long)minute,(long)seconds];
    }
    if(startTime <= currentTime && currentTime <= endTime){
        NSInteger hour = (endTime-currentTime)/3600;
        NSInteger minute = (endTime-currentTime)%3600/60;
        NSInteger seconds = (endTime-currentTime)%3600%60/60;
        limitTime = [NSString stringWithFormat:@"还剩下%ld小时%ld分%ld秒",(long)hour,(long)minute,(long)seconds];
    }
    if(currentTime >= endTime){
        limitTime = @"抢购时间已结束";
    }
    return limitTime;
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    GoodsInfoEntity *entity = cellInfo;
    if(entity.postage == Goods_Postage_None){
        return T_GoodsInfoDescHeight+25;
    }
    return T_GoodsInfoDescHeight;
}

@end
