//
//  RefundConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundConsultCell.h"
#import "OrderListEntity.h"

@interface RefundConsultCell(){
    WXUIButton *_circleBtn;
    WXUILabel *_pricelabel;
    
    BOOL selected;
}
@end

@implementation RefundConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xGap = 10;
        UIImage *circleImg = [UIImage imageNamed:@"ShoppingCartCircle.png"];
        _circleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(xGap, (RefundConsultCellHeight-circleImg.size.height)/2, circleImg.size.width, circleImg.size.height);
        [_circleBtn setBackgroundColor:[UIColor clearColor]];
        [_circleBtn setImage:circleImg forState:UIControlStateNormal];
        [_circleBtn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_circleBtn];
        
        xGap += 5+circleImg.size.width;
        CGFloat imgWidth = 58;
        CGFloat imgHeight = 20;
        UILabel *allLabel = [[UILabel alloc] init];
        allLabel.frame = CGRectMake(xGap, (RefundConsultCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [allLabel setBackgroundColor:[UIColor clearColor]];
        [allLabel setTextAlignment:NSTextAlignmentLeft];
        [allLabel setText:@"全选"];
        [allLabel setTextColor:WXColorWithInteger(0x000000)];
        [allLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:allLabel];
        
        
        CGFloat xOffset = 10;
        CGFloat btnwidth = 72;
        CGFloat btnHeight = 35;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnwidth, (RefundConsultCellHeight-btnHeight)/2, btnwidth, btnHeight);
        [btn setBorderRadian:2.0 width:0.1 color:WXColorWithInteger(0xdd2726)];
        [btn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [btn setTitle:@"退款" forState:UIControlStateNormal];
        [btn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
        [btn.titleLabel setFont:WXFont(15.0)];
        [btn addTarget:self action:@selector(refundBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        CGFloat priceLabelWidth = 85;
        CGFloat priceLabelHeight = 18;
        xOffset += btnwidth+20+priceLabelWidth;
        _pricelabel = [[WXUILabel alloc] init];
        _pricelabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, (RefundConsultCellHeight-priceLabelHeight)/2, priceLabelWidth, priceLabelHeight);
        [_pricelabel setBackgroundColor:[UIColor clearColor]];
        [_pricelabel setTextAlignment:NSTextAlignmentRight];
        [_pricelabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_pricelabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_pricelabel];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;

    CGFloat price = 0.0;
    for(OrderListEntity *ent in entity.goodsArr){
        if(ent.selected){
            price += ent.factPayMoney;
        }else{
//            price = 0.0;
        }
    }
    [_pricelabel setText:[NSString stringWithFormat:@"合计: ￥%.2f",price]];
    [self setCircleBtnImgWith:entity.selectAll];
}

//选择按钮点击
-(void)circleBtnClick{
    OrderListEntity *entity = self.cellInfo;
    if(!selected){
        selected = YES;
        entity.selectAll = YES;
    }else{
        selected = NO;
        entity.selectAll = NO;
    }
    for(OrderListEntity *ent in entity.goodsArr){
        ent.selected = entity.selectAll;
        if(ent.refund_status != Refund_Status_Normal){
            ent.selected = NO;
        }
    }
    if(_delegate && [_delegate respondsToSelector:@selector(selectAllGoods)]){
        [_delegate selectAllGoods];
    }
    [self setCircleBtnImgWith:selected];
}

-(void)setCircleBtnImgWith:(BOOL)select{
    if(select){
        [_circleBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        [_circleBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }
}

-(void)refundBtn{
    OrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(refundGoodsBtnClicked:)]){
        [_delegate refundGoodsBtnClicked:entity];
    }
}

@end
