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
    WXUIButton *btn;
    
    BOOL selected;
}
@end

@implementation RefundConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xGap = 10;
        UIImage *circleImg = [UIImage imageNamed:@"ShoppingCartCircle.png"];
        CGSize size = circleImg.size;
        size.width += 3.0;
        size.height += 3.0;
        _circleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(xGap, (RefundConsultCellHeight-size.height)/2, size.width, size.height);
        [_circleBtn setBackgroundColor:[UIColor clearColor]];
        [_circleBtn setImage:circleImg forState:UIControlStateNormal];
        [_circleBtn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_circleBtn];
        
        xGap += 5+size.width;
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
        btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnwidth, (RefundConsultCellHeight-btnHeight)/2, btnwidth, btnHeight);
        [btn setBorderRadian:2.0 width:0.1 color:WXColorWithInteger(0xdd2726)];
        [btn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [btn setTitle:@"退款" forState:UIControlStateNormal];
        [btn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
        [btn.titleLabel setFont:WXFont(15.0)];
        [btn addTarget:self action:@selector(refundBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        CGFloat priceLabelWidth = 95;
        CGFloat priceLabelHeight = 18;
        xOffset += btnwidth+20+priceLabelWidth;
        _pricelabel = [[WXUILabel alloc] init];
        _pricelabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, (RefundConsultCellHeight-priceLabelHeight)/2, priceLabelWidth, priceLabelHeight);
        [_pricelabel setBackgroundColor:[UIColor clearColor]];
        [_pricelabel setTextAlignment:NSTextAlignmentLeft];
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
    _pricelabel.frame = CGRectMake(self.frame.size.width - 95 - 20 - 72, (self.frame.size.height - 18) / 2, 95, 18);
    [_pricelabel setText:[NSString stringWithFormat:@"合计: ￥%.2f",price]];
    
    
    [self setCircleBtnImgWith:entity.selectAll];
    
    NSInteger num = 0;
    for(OrderListEntity *ent in entity.goodsArr){
        if(ent.refund_status != Refund_Status_Normal){
            num++;
        }
    }
    if(num == [entity.goodsArr count]){
        [btn setHidden:YES];
    }
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
