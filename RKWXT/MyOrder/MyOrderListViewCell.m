//
//  MyOrderListViewCell.m
//  Woxin2.0
//
//  Created by qq on 14-8-11.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "MyOrderListViewCell.h"
#import "OrderListEntity.h"
#import "WXGoodListModel.h"

@interface MyOrderListViewCell (){
    WXUILabel *_time;
    WXUILabel *_orderNum;
    WXUILabel *_orderType;
    WXUILabel *_officeName;
    WXUILabel *_dishes;
    WXUILabel *_line2;
    WXUILabel *_label2;
    WXUILabel *_money;
    WXUIButton *useRpBtn;
    WXUILabel *_downLine;
}

@end

@implementation MyOrderListViewCell

-(void)dealloc{
    RELEASE_SAFELY(_time);
    RELEASE_SAFELY(_dishes);
    RELEASE_SAFELY(_money);
    RELEASE_SAFELY(_line2);
    RELEASE_SAFELY(_label2);
    RELEASE_SAFELY(_orderNum);
    RELEASE_SAFELY(_orderType);
    RELEASE_SAFELY(_officeName);
    RELEASE_SAFELY(_downLine);
    _delegate = nil;
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        WXUILabel *topLine = [[WXUILabel alloc] init];
        topLine.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 0.5);
        [topLine setBackgroundColor:WXColorWithInteger(0xCBCBCB)];
        [self.contentView addSubview:topLine];
        RELEASE_SAFELY(topLine);
        
        CGFloat yOffset = 5;
        CGFloat timeWidth = 240;
        CGFloat timeHeight = 15;
        _time = [[WXUILabel alloc] init];
        _time.frame = CGRectMake((IPHONE_SCREEN_WIDTH-timeWidth)/2, yOffset, timeWidth, timeHeight);
        [_time setBackgroundColor:[UIColor clearColor]];
        [_time setTextAlignment:NSTextAlignmentCenter];
        [_time setTextColor:WXColorWithInteger(0x969696)];
        [_time setFont:[UIFont systemFontOfSize:11.0]];
        [self.contentView addSubview:_time];
        
        CGFloat xOffset = 6;
        yOffset += timeHeight;
        CGFloat orderNumWidth = 160;
        CGFloat orderNumHeight = 15;
        _orderNum = [[WXUILabel alloc] init];
        _orderNum.frame = CGRectMake(xOffset+10, yOffset, orderNumWidth, orderNumHeight);
        [_orderNum setBackgroundColor:[UIColor clearColor]];
        [_orderNum setTextAlignment:NSTextAlignmentLeft];
        [_orderNum setTextColor:WXColorWithInteger(0x969696)];
        [_orderNum setFont:[UIFont systemFontOfSize:11.0]];
        [self.contentView addSubview:_orderNum];
        
        
        CGFloat orderTypeWidth = 100;
        CGFloat orderTypeHeight = 15;
        _orderType = [[WXUILabel alloc] init];
        _orderType.frame = CGRectMake(IPHONE_SCREEN_WIDTH-30-orderTypeWidth, yOffset, orderTypeWidth, orderTypeHeight);
        [_orderType setBackgroundColor:[UIColor clearColor]];
        [_orderType setTextAlignment:NSTextAlignmentRight];
        [_orderType setTextColor:WXColorWithInteger(0x969696)];
        [_orderType setFont:[UIFont systemFontOfSize:11.0]];
		if (!kIsAppModePublic){
			[self.contentView addSubview:_orderType];
		}
        
        yOffset += timeHeight+5;
        WXUILabel *line1 = [[WXUILabel alloc] init];
        line1.frame = CGRectMake(10, yOffset, IPHONE_SCREEN_WIDTH-20, 0.5);
        [line1 setBackgroundColor:WXColorWithInteger(0xEBEBEB)];
        [self.contentView addSubview:line1];
        RELEASE_SAFELY(line1);
        
        
        yOffset += 8;
        CGFloat label1Width = 200;
        CGFloat label1Height = 17;
        _officeName = [[WXUILabel alloc] init];
        _officeName.frame = CGRectMake(xOffset+5, yOffset, label1Width, label1Height);
        [_officeName setBackgroundColor:[UIColor clearColor]];
        [_officeName setTextAlignment:NSTextAlignmentLeft];
        [_officeName setFont:[UIFont systemFontOfSize:15.0]];
        [_officeName setTextColor:WXColorWithInteger(0x969696)];
        [self.contentView addSubview:_officeName];
        
        
        yOffset += label1Height+3;
        _dishes = [[WXUILabel alloc] init];
        _dishes.frame = CGRectMake(10, yOffset, IPHONE_SCREEN_WIDTH-20, 0);
        [_dishes setBackgroundColor:[UIColor clearColor]];
        [_dishes setFont:[UIFont systemFontOfSize:14.0]];
        [_dishes setNumberOfLines:0];
        [_dishes setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:_dishes];
        
//        yOffset += frame.size.height+5;
        _line2 = [[WXUILabel alloc] init];
        _line2.frame = CGRectMake(10, yOffset, IPHONE_SCREEN_WIDTH-20, 0.5);
        [_line2 setBackgroundColor:WXColorWithInteger(0xEBEBEB)];
        [self.contentView addSubview:_line2];
        
        
        yOffset += 10;
        xOffset = 10;
        CGFloat label2Width = 65;
        CGFloat label2Height = 15;
        _label2 = [[WXUILabel alloc] init];
        _label2.frame = CGRectMake(xOffset, yOffset, label2Width, label2Height);
        [_label2 setBackgroundColor:[UIColor clearColor]];
		NSString *txt = @"点菜合计:";
		if (kIsAppModePublic){
			txt = @"商品合计:";
		}
        [_label2 setText:txt];
        [_label2 setTextAlignment:NSTextAlignmentLeft];
        [_label2 setFont:[UIFont systemFontOfSize:12.0]];
        [_label2 setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:_label2];
        
        xOffset += label2Width+5;
        CGFloat moneyWidth = IPHONE_SCREEN_WIDTH-xOffset;
        CGFloat moneyHeght = 15;
        _money = [[WXUILabel alloc] init];
        _money.frame = CGRectMake(xOffset, yOffset, moneyWidth, moneyHeght);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setFont:[UIFont systemFontOfSize:12.0]];
        [_money setTextColor:WXColorWithInteger(0xff5566)];
        [self.contentView addSubview:_money];
        
        CGFloat label3Width = 80;
        CGFloat label3Height = 25;
        useRpBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        useRpBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-label3Width-10, yOffset, label3Width, label3Height);
        [useRpBtn setBorderRadian:10.0 width:0.7 color:[UIColor redColor]];
        [useRpBtn setBackgroundColor:[UIColor redColor]];
        [useRpBtn setTitle:@"使用红包" forState:UIControlStateNormal];
        [useRpBtn addTarget:self action:@selector(useRedPager:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:useRpBtn];
        
        yOffset += label3Height+3;
        
        _downLine = [[WXUILabel alloc] init];
        _downLine.frame = CGRectMake(0, yOffset, IPHONE_SCREEN_WIDTH, 0.5);
        [_downLine setBackgroundColor:WXColorWithInteger(0xCBCBCB)];
        [self.contentView addSubview:_downLine];
    }
    return self;
}

-(void)load{
    OrderListEntity *orderEntity = self.cellInfo;
    NSString *foodName = [[[NSString alloc] init] autorelease];
    NSInteger count = 0;
    NSInteger num = 0;
    CGFloat money = 0.0;
    CGFloat price = 0.0;
    NSInteger lastNum = 0;
    for(NSDictionary *dic in orderEntity.dataArr){
        lastNum++;
        if(lastNum != [orderEntity.dataArr count]){
            foodName = [foodName stringByAppendingString:[NSString stringWithFormat:@"%@、",[dic objectForKey:@"name"]]];
        }else{
            foodName = [foodName stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
        }
        
        num = [[dic objectForKey:@"num"] integerValue];
        count += num;
        money = [[dic objectForKey:@"price"] floatValue];
        price += num * money;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:orderEntity.time];
	NSString *orderTimeStr = @"订单时间";
    [_time setText:[NSString stringWithFormat:@"%@:%@",orderTimeStr,[date YMRSFMString]]];
    [_orderNum setText:[NSString stringWithFormat:@"订单号: %@",orderEntity.order_id]];
    [_officeName setText:orderEntity.shop_name];
    if(orderEntity.type == 1){
        [_orderType setText:[NSString stringWithFormat:@"订单类型: 到店"]];
    }else{
        [_orderType setText:[NSString stringWithFormat:@"订单类型: 外卖"]];
    }
    [_dishes setText:foodName];
	NSString *unit = @"份";
	if (kIsAppModePublic){
		unit = @"件";
	}
	NSString *priceString = [UtilTool convertFloatToString:price];
	[_money setText:[NSString stringWithFormat:@"%ld%@,合计￥%@",(long)count,unit,priceString]];
	
    [self setUseRpBtnStatus:orderEntity.shop_name withUseMoney:orderEntity.red_package];
    CGFloat height = [foodName stringHeight:[UIFont systemFontOfSize:14.0] width:300];
    [self setframe:height];
}

-(void)setframe:(CGFloat)height{
    CGRect rect = _dishes.frame;
    rect.size.height = height;
    [_dishes setFrame:rect];
    
    CGRect rect1 = _line2.frame;
    rect1.origin.y = rect.origin.y+height+5;
    [_line2 setFrame:rect1];
    
    CGRect rect2 = _label2.frame;
    rect2.origin.y = rect1.origin.y+10;
    [_label2 setFrame:rect2];
    
    CGRect rect3 = _money.frame;
    rect3.origin.y = rect2.origin.y;
    [_money setFrame:rect3];
    
    CGRect rect4 = useRpBtn.frame;
    rect4.origin.y = rect3.origin.y;
    [useRpBtn setFrame:rect4];
    
    CGRect rect5 = _downLine.frame;
    rect5.origin.y = rect2.origin.y+28;
    [_downLine setFrame:rect5];
}

-(void)setUseRpBtnStatus:(NSString *)shopName withUseMoney:(NSInteger)money{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(money > 0 || ![shopName isEqualToString:userObj.subShopName]){
        [useRpBtn setEnabled:NO];
        [useRpBtn setBackgroundColor:WXColorWithInteger(0xDCDCDC)];
        [useRpBtn setBorderRadian:10.0 width:0.7 color:WXColorWithInteger(0xDCDCDC)];
    }else{
        [useRpBtn setEnabled:YES];
        [useRpBtn setBorderRadian:10.0 width:0.7 color:[UIColor redColor]];
        [useRpBtn setBackgroundColor:[UIColor redColor]];
    }
}

-(void)useRedPager:(id)entity{
    if(_delegate && [_delegate respondsToSelector:@selector(useRedPager:)]){
        [_delegate useRedPager:self.cellInfo];
    }
}

- (CGSize)sizeOfString:(NSString *)txt font:(UIFont *)font{
    if(!txt || [txt isKindOfClass:[NSNull class]]){
        txt = @" ";
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [txt sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [txt sizeWithFont:font];
    }
}

@end
