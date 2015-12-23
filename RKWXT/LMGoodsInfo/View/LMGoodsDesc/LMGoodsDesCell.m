//
//  LMGoodsDesCell.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsDesCell.h"
#import "LMGoodsInfoEntity.h"

@interface LMGoodsDesCell(){
    WXUILabel *desLabel;
    WXUILabel *shopPrice;
    WXUILabel *marketPrice;
    WXUILabel *lineLabel;
    WXUIButton *usercutBtn;
    WXUIButton *carriageBtn;
}
@end

@implementation LMGoodsDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat yOffset = 12;
        CGFloat desWidth = IPHONE_SCREEN_WIDTH-2*xOffset;
        CGFloat desHeight = 35;
        desLabel = [[WXUILabel alloc] init];
        desLabel.frame = CGRectMake(xOffset, yOffset, desWidth, desHeight);
        [desLabel setBackgroundColor:[UIColor clearColor]];
        [desLabel setTextAlignment:NSTextAlignmentCenter];
        [desLabel setFont:WXFont(14.0)];
        [desLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:desLabel];
        
        yOffset += desHeight+6;
        CGFloat priceLabelWidth = 120;
        CGFloat priceLabelHeight = 20;
        shopPrice = [[WXUILabel alloc] init];
        shopPrice.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2-20-priceLabelWidth, yOffset, priceLabelWidth, priceLabelHeight);
        [shopPrice setBackgroundColor:[UIColor clearColor]];
        [shopPrice setTextAlignment:NSTextAlignmentRight];
        [shopPrice setTextColor:WXColorWithInteger(0xdd2726)];
        [shopPrice setFont:WXFont(17.0)];
        [self.contentView addSubview:shopPrice];
        
        marketPrice = [[WXUILabel alloc] init];
        marketPrice.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2+20, yOffset, priceLabelWidth, priceLabelHeight);
        [marketPrice setBackgroundColor:[UIColor clearColor]];
        [marketPrice setTextAlignment:NSTextAlignmentLeft];
        [marketPrice setTextColor:WXColorWithInteger(0x9b9b9b)];
        [marketPrice setFont:WXFont(14.0)];
        [self.contentView addSubview:marketPrice];
        
        lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(0, priceLabelHeight/2, priceLabelWidth/2, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [marketPrice addSubview:lineLabel];
        
        yOffset += priceLabelHeight+13;
        CGFloat btnWidth = 70;
        CGFloat btnHieght = 18;
        usercutBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        usercutBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [usercutBtn setBackgroundColor:[UIColor whiteColor]];
        [usercutBtn setBorderRadian:2.0 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [usercutBtn setImage:[UIImage imageNamed:@"LMUserCutImg.png"] forState:UIControlStateNormal];
        [usercutBtn setTitle:@"提成" forState:UIControlStateNormal];
        [usercutBtn.titleLabel setFont:WXFont(9.0)];
        [usercutBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [usercutBtn setHidden:YES];
        [usercutBtn addTarget:self action:@selector(userCutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:usercutBtn];
        
        xOffset += btnWidth+10;
        carriageBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        carriageBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [carriageBtn setBackgroundColor:[UIColor whiteColor]];
        [carriageBtn setBorderRadian:2.0 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [carriageBtn setImage:[UIImage imageNamed:@"LMCarriageImg.png"] forState:UIControlStateNormal];
        [carriageBtn setTitle:@"包邮" forState:UIControlStateNormal];
        [carriageBtn.titleLabel setFont:WXFont(9.0)];
        [carriageBtn setHidden:YES];
        [carriageBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [carriageBtn addTarget:self action:@selector(carriageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:carriageBtn];
    }
    return self;
}

-(void)load{
    LMGoodsInfoEntity *entity = self.cellInfo;
    [desLabel setText:entity.goodsName];
    
    NSString *marketPriceString = [NSString stringWithFormat:@"￥%.2f",entity.marketPrice];  //￥金额符号
    [shopPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.shopPrice]];
    [marketPrice setText:marketPriceString];
    
    CGRect rect = lineLabel.frame;
    rect.size.width = [NSString widthForString:marketPriceString fontSize:14.0 andHeight:20];
    [lineLabel setFrame:rect];
    
    if(_userCut){
        [usercutBtn setHidden:NO];
    }
    if(entity.postage == LMGoods_Postage_None && _userCut){
        [carriageBtn setHidden:NO];
    }
    if(entity.postage == LMGoods_Postage_None && !_userCut){
        [carriageBtn setHidden:NO];
        CGRect rect = carriageBtn.frame;
        rect.origin.x = 12;
        [carriageBtn setFrame:rect];
    }
    if(entity.postage == LMGoods_Postage_Have && !_userCut){
        [carriageBtn setHidden:YES];
        [usercutBtn setHidden:YES];
    }
}

-(void)userCutBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(lmGoodsInfoDesCutBtnClicked)]){
        [_delegate lmGoodsInfoDesCutBtnClicked];
    }
}

-(void)carriageBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(lmGoodsInfoDesCarriageBtnClicked)]){
        [_delegate lmGoodsInfoDesCarriageBtnClicked];
    }
}

@end
