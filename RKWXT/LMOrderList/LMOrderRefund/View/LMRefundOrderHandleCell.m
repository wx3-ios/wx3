//
//  LMRefundOrderHandleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMRefundOrderHandleCell.h"
#import "LMOrderListEntity.h"

@interface LMRefundOrderHandleCell(){
    WXUIButton *_circleBtn;
    WXUILabel *_pricelabel;
    WXUIButton *btn;
    
    BOOL selected;
}
@end

@implementation LMRefundOrderHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xGap = 10;
        UIImage *circleImg = [UIImage imageNamed:@"ShoppingCartCircle.png"];
        CGSize size = circleImg.size;
        size.width += 3.0;
        size.height += 3.0;
        _circleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(xGap, (LMRefundOrderHandleCellHeight-size.height)/2, size.width, size.height);
        [_circleBtn setBackgroundColor:[UIColor clearColor]];
        [_circleBtn setImage:circleImg forState:UIControlStateNormal];
        [_circleBtn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_circleBtn];
        
        xGap += 5+size.width;
        CGFloat imgWidth = 58;
        CGFloat imgHeight = 20;
        UILabel *allLabel = [[UILabel alloc] init];
        allLabel.frame = CGRectMake(xGap, (LMRefundOrderHandleCellHeight-imgHeight)/2, imgWidth, imgHeight);
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
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnwidth, (LMRefundOrderHandleCellHeight-btnHeight)/2, btnwidth, btnHeight);
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
        _pricelabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, (LMRefundOrderHandleCellHeight-priceLabelHeight)/2, priceLabelWidth, priceLabelHeight);
        [_pricelabel setBackgroundColor:[UIColor clearColor]];
        [_pricelabel setTextAlignment:NSTextAlignmentRight];
        [_pricelabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_pricelabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_pricelabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    
    CGFloat price = 0.0;
    for(LMOrderListEntity *ent in entity.goodsListArr){
        if(ent.selected){
            price += ent.goodsValue;
        }else{
            price += 0.0;
        }
    }
    [_pricelabel setText:[NSString stringWithFormat:@"合计: ￥%.2f",price]];
    [self setCircleBtnImgWith:entity.selectAll];
    
    NSInteger num = 0;
    for(LMOrderListEntity *ent in entity.goodsListArr){
        if(ent.refundState != LMRefund_State_Normal){
            num++;
        }
    }
    if(num == [entity.goodsListArr count]){
        [btn setHidden:YES];
        [_circleBtn setHidden:YES];
    }
}

//选择按钮点击
-(void)circleBtnClick{
    LMOrderListEntity *entity = self.cellInfo;
    if(!selected){
        selected = YES;
        entity.selectAll = YES;
    }else{
        selected = NO;
        entity.selectAll = NO;
    }
    for(LMOrderListEntity *ent in entity.goodsListArr){
        ent.selected = entity.selectAll;
        if(ent.refundState != LMRefund_State_Normal){
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
    LMOrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(lmRefundGoodsBtnClicked:)]){
        [_delegate lmRefundGoodsBtnClicked:entity];
    }
}

@end
