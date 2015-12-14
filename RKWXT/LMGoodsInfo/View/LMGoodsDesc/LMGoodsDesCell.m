//
//  LMGoodsDesCell.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsDesCell.h"

@interface LMGoodsDesCell(){
    WXUILabel *desLabel;
    WXUILabel *shopPrice;
    WXUILabel *marketPrice;
    WXUILabel *lineLabel;
    WXUIButton *redpacketBtn;
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
        [marketPrice setTextColor:WXColorWithInteger(0xfafafa)];
        [marketPrice setFont:WXFont(14.0)];
        [self.contentView addSubview:marketPrice];
        
        lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(0, yOffset+priceLabelHeight/2, priceLabelWidth, 0.5);
        [lineLabel setBackgroundColor:WXColorWithInteger(0xfafafa)];
        [marketPrice addSubview:lineLabel];
        
        yOffset += priceLabelHeight+13;
        CGFloat btnWidth = 70;
        CGFloat btnHieght = 18;
        redpacketBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        redpacketBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [redpacketBtn setBackgroundColor:[UIColor whiteColor]];
        [redpacketBtn setBorderRadian:2.0 width:0.5 color:[UIColor grayColor]];
        [redpacketBtn setTitle:@"使用红包" forState:UIControlStateNormal];
        [redpacketBtn addTarget:self action:@selector(redpacketBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:redpacketBtn];
        
        xOffset += btnWidth+10;
        usercutBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        usercutBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [usercutBtn setBackgroundColor:[UIColor whiteColor]];
        [usercutBtn setBorderRadian:2.0 width:0.5 color:[UIColor grayColor]];
        [usercutBtn setTitle:@"提成" forState:UIControlStateNormal];
        [usercutBtn addTarget:self action:@selector(userCutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:usercutBtn];
        
        xOffset += btnWidth+10;
        carriageBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        carriageBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [carriageBtn setBackgroundColor:[UIColor whiteColor]];
        [carriageBtn setBorderRadian:2.0 width:0.5 color:[UIColor grayColor]];
        [carriageBtn setTitle:@"包邮" forState:UIControlStateNormal];
        [carriageBtn addTarget:self action:@selector(carriageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:carriageBtn];
    }
    return self;
}

-(void)load{
    
}

-(void)redpacketBtnClicked{
    
}

-(void)userCutBtnClicked{
    
}

-(void)carriageBtnClicked{
    
}

@end
