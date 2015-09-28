//
//  WaitReceiveCell.m
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitReceiveCell.h"
#import "UserBonusEntity.h"

#define cellHeight (59)

@interface WaitReceiveCell(){
    UILabel *_moneyLabel;
    UILabel *_datelaebl;
}
@end

@implementation WaitReceiveCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 17;
        CGFloat textlabelWidth = 14;
        CGFloat textlabelHeight = 14;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (cellHeight-textlabelHeight)/2+3, textlabelWidth, textlabelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"￥"];
        [textLabel setTextAlignment:NSTextAlignmentRight];
        [textLabel setFont:WXFont(12.0)];
        [textLabel setTextColor:WXColorWithInteger(0xdc2826)];
        [self.contentView addSubview:textLabel];
        
        xOffset += textlabelWidth;
        CGFloat moneyWidth = 60;
        CGFloat moneyHeight = 28;
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.frame = CGRectMake(xOffset, (cellHeight-moneyHeight)/2, moneyWidth, moneyHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextAlignment:NSTextAlignmentLeft];
        [_moneyLabel setFont:WXFont(22.0)];
        [_moneyLabel setTextColor:WXColorWithInteger(0xdc2826)];
        [self.contentView addSubview:_moneyLabel];
        
        xOffset += moneyWidth+6;
        CGFloat dateWidth = 160;
        CGFloat dateheight = 15;
        _datelaebl = [[UILabel alloc] init];
        _datelaebl.frame = CGRectMake(xOffset, (cellHeight-dateheight)/2, dateWidth, dateheight);
        [_datelaebl setBackgroundColor:[UIColor clearColor]];
        [_datelaebl setTextAlignment:NSTextAlignmentLeft];
        [_datelaebl setTextColor:WXColorWithInteger(0x828282)];
        [_datelaebl setFont:WXFont(13.0)];
        [self.contentView addSubview:_datelaebl];
        
        CGFloat xGap = 17;
        CGFloat btnWidth = 50;
        CGFloat btnHeight = 28;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.bounds.size.width-xGap-btnWidth, (cellHeight-btnHeight)/2, btnWidth, btnHeight);
        [btn setBorderRadian:6.0 width:1.0 color:[UIColor clearColor]];
        [btn setBackgroundColor:WXColorWithInteger(0xdc2826)];
        [btn setTitle:@"领取" forState:UIControlStateNormal];
        [btn.titleLabel setFont:WXFont(15.0)];
        [btn addTarget:self action:@selector(receive) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)load{
    UserBonusEntity *entity = self.cellInfo;
    NSString *money = [NSString stringWithFormat:@"%ld",(long)entity.bonusValue];
    [_moneyLabel setText:money];
    NSString *dateStr = [NSString stringWithFormat:@"%@之前有效",[self canLoadUserBonusDate:entity.end_time]];
    [_datelaebl setText:dateStr];
    
    CGSize size = [self sizeOfString:money font:WXFont(22.0)];
    CGRect rect = _moneyLabel.frame;
    rect.size.width = size.width;
    [_moneyLabel setFrame:rect];
    
    CGRect rect1 = _datelaebl.frame;
    rect1.origin.x = rect.origin.x+rect.size.width+4;
    [_datelaebl setFrame:rect1];
}

-(NSString*)canLoadUserBonusDate:(NSInteger)date{
    if(date < [UtilTool timeChange]){
        return nil;
    }
    NSString *dateStr = nil;
    dateStr = [UtilTool getDateTimeFor:date type:2];
    return dateStr;
}

-(void)receive{
    UserBonusEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(receiveBonus:)]){
        [_delegate receiveBonus:entity];
    }
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return cellHeight;
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
