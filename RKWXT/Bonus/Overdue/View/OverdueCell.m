//
//  OverdueCell.m
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OverdueCell.h"
#import "UserBonusEntity.h"

#define cellHeight (59)

@interface OverdueCell(){
    UILabel *_moneyLabel;
    UILabel *_datelaebl;
}
@end

@implementation OverdueCell

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
        [textLabel setTextColor:WXColorWithInteger(0x686868)];
        [self.contentView addSubview:textLabel];
        
        xOffset += textlabelWidth;
        CGFloat moneyWidth = 42;
        CGFloat moneyHeight = 28;
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.frame = CGRectMake(xOffset, (cellHeight-moneyHeight)/2, moneyWidth, moneyHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextAlignment:NSTextAlignmentLeft];
        [_moneyLabel setFont:WXFont(22.0)];
        [_moneyLabel setTextColor:WXColorWithInteger(0x686868)];
        [self.contentView addSubview:_moneyLabel];
        
        xOffset += moneyWidth+6;
        CGFloat dateWidth = 160;
        CGFloat dateheight = 15;
        _datelaebl = [[UILabel alloc] init];
        _datelaebl.frame = CGRectMake(xOffset, (cellHeight-dateheight)/2, dateWidth, dateheight);
        [_datelaebl setBackgroundColor:[UIColor clearColor]];
        [_datelaebl setTextAlignment:NSTextAlignmentLeft];
        [_datelaebl setTextColor:WXColorWithInteger(0x686868)];
        [_datelaebl setFont:WXFont(13.0)];
        [self.contentView addSubview:_datelaebl];
        
        CGFloat xGap = 17;
        CGFloat btnWidth = 60;
        CGFloat btnHeight = 28;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.bounds.size.width-xGap-btnWidth, (cellHeight-btnHeight)/2, btnWidth, btnHeight);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:@"不可领取" forState:UIControlStateNormal];
        [btn.titleLabel setFont:WXFont(15.0)];
        [btn setTitleColor:WXColorWithInteger(0x686868) forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)load{
    UserBonusEntity *entity = self.cellInfo;
    NSString *moneyStr = [NSString stringWithFormat:@"%ld",(long)entity.bonusValue];
    [_moneyLabel setText:moneyStr];
    [_datelaebl setText:[self bonusDescriptionWithEnt:entity]];
}

-(NSString *)bonusDescriptionWithEnt:(UserBonusEntity*)entity{
    NSString *desc = nil;
    if(entity.begin_time > [UtilTool timeChange]){  //开始领取时间大于当前时间
        desc = [NSString stringWithFormat:@"%@日开始领取",[UtilTool getDateTimeFor:entity.begin_time type:2]];
        return desc;
    }
    if(entity.end_time < [UtilTool timeChange]){
        desc = @"红包已过期";
        return desc;
    }
    return @"红包已领取";
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return cellHeight;
}

@end

