//
//  MakeOrderUserBalanceCell.m
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderUserBalanceCell.h"
#import "MakeOrderDef.h"
#import "GoodsInfoEntity.h"

@interface MakeOrderUserBalanceCell(){
    UILabel *_useBonus;
    UILabel *_money;
}
@end

@implementation MakeOrderUserBalanceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12.0;
        CGSize useSize = [self sizeOfString:@"使用" font:WXFont(15.0)];
        UILabel *useLabel = [[UILabel alloc] init];
        useLabel.frame = CGRectMake(xOffset, (Order_Section_Height_BonusInfo-useSize.height)/2, useSize.width, useSize.height);
        [useLabel setBackgroundColor:[UIColor clearColor]];
        [useLabel setTextAlignment:NSTextAlignmentRight];
        [useLabel setTextColor:WXColorWithInteger(0x646464)];
        [useLabel setText:@"使用"];
        [useLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:useLabel];
        
        xOffset += useSize.width;
        CGFloat labelWidth = 30;
        CGFloat labelHeight = 20;
        _useBonus = [[UILabel alloc] init];
        _useBonus.frame = CGRectMake(xOffset, (Order_Section_Height_BonusInfo-labelHeight)/2, labelWidth, labelHeight);
        [_useBonus setBackgroundColor:[UIColor whiteColor]];
        [_useBonus setBorderRadian:2.0 width:0.2 color:WXColorWithInteger(0x646464)];
        [_useBonus setTextAlignment:NSTextAlignmentCenter];
        [_useBonus setTextColor:WXColorWithInteger(0x646464)];
        [_useBonus setFont:WXFont(14.0)];
        [self.contentView addSubview:_useBonus];
        
        xOffset += labelWidth;
        CGSize textSize = [self sizeOfString:@"元余额," font:WXFont(15.0)];
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (Order_Section_Height_BonusInfo-textSize.height)/2, textSize.width, textSize.height);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x646464)];
        [textLabel setText:@"元余额,"];
        [textLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:textLabel];
        
        xOffset += textSize.width;
        CGFloat moneyWidth = 103;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(xOffset, (Order_Section_Height_BonusInfo-textSize.height)/2, moneyWidth, textSize.height);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setTextColor:WXColorWithInteger(0x646464)];
        [_money setFont:WXFont(15.0)];
        [self.contentView addSubview:_money];
    }
    return self;
}

-(void)load{
    NSInteger bonus = [self.cellInfo integerValue];
    NSString *bonusStr = [NSString stringWithFormat:@"%ld",(long)bonus];
    [_useBonus setText:bonusStr];
    [_money setText:[NSString stringWithFormat:@"抵用金额%@元",bonusStr]];
}

- (CGSize)sizeOfString:(NSString*)txt font:(UIFont*)font{
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