//
//  OrderUserHandleCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderUserHandleCell.h"

@interface OrderUserHandleCell(){
    WXUIButton *_cancelBtn;
}
@end

@implementation OrderUserHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 88;
        CGFloat btnWidth = 76;
        CGFloat btnHeight = 35;
        _cancelBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(size.width-xOffset, (OrderHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [_cancelBtn setBorderRadian:4.0 width:0.5 color:[UIColor clearColor]];
        [_cancelBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [_cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [self.contentView addSubview:_cancelBtn];
    }
    return self;
}

-(void)load{
    
}

-(void)cancelOrder{
    
}

@end
