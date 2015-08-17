//
//  LuckyOrderContactSellerCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderContactSellerCell.h"

@interface LuckyOrderContactSellerCell(){
    WXUIButton *rightBtn;
}
@end

@implementation LuckyOrderContactSellerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = (IPHONE_SCREEN_WIDTH-3*xOffset)/2;
        CGFloat btnHeight = 34;
        WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(xOffset, (LuckyOrderContactSellerCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [leftBtn setBackgroundColor:WXColorWithInteger(0x848484)];
        [leftBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:leftBtn];
        
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (LuckyOrderContactSellerCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [rightBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
    }
    return self;
}

-(void)load{
    
}

-(void)leftBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(luckyOrderLeftBtnClicked)]){
        [_delegate luckyOrderLeftBtnClicked];
    }
}

-(void)rightBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(luckyOrderRightBtnClicked)]){
        [_delegate luckyOrderRightBtnClicked];
    }
}

@end
