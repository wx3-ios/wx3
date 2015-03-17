//
//  OrderInfoPersonalView.m
//  Woxin2.0
//
//  Created by qq on 14-8-11.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "OrderInfoPersonalView.h"
#import "OrderListEntity.h"

@interface OrderInfoPersonalView (){
    WXUILabel *_orderType;
    WXUILabel *_phone;
    WXUILabel *_number;
    WXUILabel *_remarks;
    WXUILabel *_address;
    WXUILabel *_rpAlert;
}
@property (nonatomic,retain) UIView *footView;
@end

@implementation OrderInfoPersonalView

-(void)dealloc{
    RELEASE_SAFELY(_orderType);
    RELEASE_SAFELY(_phone);
    RELEASE_SAFELY(_number);
    RELEASE_SAFELY(_remarks);
    RELEASE_SAFELY(_address);
    RELEASE_SAFELY(_footView);
    RELEASE_SAFELY(_rpAlert);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _footView = [[UIView alloc] init];
        [_footView setBackgroundColor:[UIColor whiteColor]];
        CGFloat remHeight = frame.size.width;
        CGFloat addHeight = frame.size.height;
        CGFloat rpHeight = frame.origin.y;
    
        CGFloat xOffset = 7;
        CGFloat yOffset = 3;
        CGFloat width = IPHONE_SCREEN_WIDTH-2*xOffset;
        CGFloat height = 15;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        UIColor *color = WXColorWithInteger(0x646464);
		
		if (!kIsAppModePublic){
			_orderType = [[WXUILabel alloc] init];
			_orderType.frame = CGRectMake(xOffset, yOffset, width, height);
			[_orderType setBackgroundColor:[UIColor clearColor]];
			[_orderType setTextAlignment:NSTextAlignmentLeft];
			[_orderType setFont:font];
			[_orderType setTextColor:color];
			[_footView addSubview:_orderType];
			yOffset += height+3;
		}
		
        _phone = [[WXUILabel alloc] init];
        _phone.frame = CGRectMake(xOffset, yOffset, width, height);
        [_phone setBackgroundColor:[UIColor clearColor]];
        [_phone setTextAlignment:NSTextAlignmentLeft];
        [_phone setFont:font];
        [_phone setTextColor:color];
        [_footView addSubview:_phone];
        
        yOffset += height+3;
        _number = [[WXUILabel alloc] init];
        _number.frame = CGRectMake(xOffset, yOffset, width, height);
        [_number setBackgroundColor:[UIColor clearColor]];
        [_number setTextAlignment:NSTextAlignmentLeft];
        [_number setFont:font];
        [_number setTextColor:color];
        [_footView addSubview:_number];
        
        
        yOffset += height+3;
        CGFloat remWidth = IPHONE_SCREEN_WIDTH-14;
        _remarks = [[WXUILabel alloc] init];
        _remarks.frame = CGRectMake(xOffset, yOffset, remWidth, remHeight);
        [_remarks setBackgroundColor:[UIColor clearColor]];
        [_remarks setTextAlignment:NSTextAlignmentLeft];
        [_remarks setFont:font];
        [_remarks setTextColor:color];
        [_remarks setNumberOfLines:0];
        [_footView addSubview:_remarks];
        
        CGFloat addWidth = IPHONE_SCREEN_WIDTH-14;
        yOffset += remHeight+3;
        _address = [[WXUILabel alloc] init];
        _address.frame = CGRectMake(xOffset, yOffset, addWidth, addHeight);
        [_address setBackgroundColor:[UIColor clearColor]];
        [_address setTextAlignment:NSTextAlignmentLeft];
        [_address setFont:font];
        [_address setTextColor:color];
        [_address setNumberOfLines:0];
        [_footView addSubview:_address];
    
        
        yOffset += addHeight+3;
        _rpAlert = [[WXUILabel alloc] init];
        _rpAlert.frame = CGRectMake(xOffset, yOffset, width, rpHeight);
        [_rpAlert setBackgroundColor:[UIColor clearColor]];
        [_rpAlert setTextAlignment:NSTextAlignmentLeft];
        [_rpAlert setFont:font];
        [_rpAlert setTextColor:[UIColor redColor]];
        [_footView addSubview:_rpAlert];
        
    
        yOffset += rpHeight+3;
        CGRect rect = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, yOffset);
        _footView.frame = rect;
    }
    return self;
}

-(UIView *)orderInfoPersonalView:(id)entity{
    OrderListEntity *orderEntity = entity;
    NSString *remarks = @"订单备注:";
    remarks = [remarks stringByAppendingString:orderEntity.remarks];
    CGFloat remHeight = [remarks stringHeight:[UIFont systemFontOfSize:14.0] width:306];
    CGFloat addHeight = 0.0;
    if(orderEntity.type != 1){
        NSString *address = @"外卖地址:";
        address = [address stringByAppendingString:orderEntity.address];
        addHeight = [address stringHeight:[UIFont systemFontOfSize:14.0] width:306];
    }
    CGFloat rpHeight = 0.0;
    CGFloat rpMoney = orderEntity.red_package;
    if(rpMoney > 0){
        rpHeight = 15.0;
    }
    [self initWithFrame:CGRectMake(0, rpHeight, remHeight, addHeight)];
    
    NSInteger type = orderEntity.type;
    if(type == 1){
        [_orderType setText:@"订单类型: 到店"];
    }else{
        [_orderType setText:@"订单类型: 外卖"];
        [_address setText:[NSString stringWithFormat:@"外卖地址: %@",orderEntity.address]];
    }
    [_phone setText:[NSString stringWithFormat:@"电话: %@",orderEntity.phoneNum]];
    [_number setText:[NSString stringWithFormat:@"订单号: %@",orderEntity.order_id]];
    [_remarks setText:[NSString stringWithFormat:@"订单备注: %@",orderEntity.remarks]];
    if(rpMoney > 0){
        [_rpAlert setText:[NSString stringWithFormat:@"提示: 该订单已使用%ld元红包",(long)rpMoney]];
    }
    
    return _footView;
}

@end
