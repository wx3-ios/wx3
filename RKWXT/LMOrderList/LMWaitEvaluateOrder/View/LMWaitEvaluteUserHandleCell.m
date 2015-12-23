//
//  LMWaitEvaluteUserHandleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMWaitEvaluteUserHandleCell.h"
#import "LMOrderListEntity.h"

@interface LMWaitEvaluteUserHandleCell(){
    WXUILabel *pricelabel;
    WXUIButton *rightBtn;
}
@end

@implementation LMWaitEvaluteUserHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelHeight = 18;
        CGFloat labelWidth = 50;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (LMWaitEvaluteUserHandleCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [textLabel setFont:WXFont(14.0)];
        [textLabel setText:@"实付款"];
        [self.contentView addSubview:textLabel];
        
        CGFloat priceLabelWidth = 90;
        pricelabel = [[WXUILabel alloc] init];
        pricelabel.frame = CGRectMake(xOffset+labelWidth, (LMWaitEvaluteUserHandleCellHeight-labelHeight)/2, priceLabelWidth, labelHeight);
        [pricelabel setBackgroundColor:[UIColor clearColor]];
        [pricelabel setTextAlignment:NSTextAlignmentLeft];
        [pricelabel setTextColor:WXColorWithInteger(0x000000)];
        [pricelabel setFont:WXFont(14.0)];
        [self.contentView addSubview:pricelabel];
        
        CGFloat btnWidth = 56;
        CGFloat btnHeight = 24;
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (LMWaitEvaluteUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [rightBtn setHidden:YES];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
        [rightBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [rightBtn.titleLabel setFont:WXFont(10.0)];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [pricelabel setText:[NSString stringWithFormat:@"￥%.2f",entity.orderMoney+entity.carriageMoney]];
    
    [self userHandleBtnState];
}

-(void)userHandleBtnState{
    LMOrderListEntity *entity = self.cellInfo;
    if(entity.evaluate == LMOrder_Evaluate_None && entity.orderState == LMorder_State_Complete){
        [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
        [rightBtn setHidden:NO];
    }
}

-(void)rightBtnClicked{
    LMOrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(userEvaluateOrder:)]){
        [_delegate userEvaluateOrder:entity];
    }
}

@end
