//
//  OverdueCell.m
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OverdueCell.h"

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
        CGFloat btnWidth = 50;
        CGFloat btnHeight = 28;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.bounds.size.width-xGap-btnWidth, (cellHeight-btnHeight)/2, btnWidth, btnHeight);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:@"已过期" forState:UIControlStateNormal];
        [btn.titleLabel setFont:WXFont(15.0)];
        [btn setTitleColor:WXColorWithInteger(0x686868) forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)load{
    [_moneyLabel setText:@"6"];
    [_datelaebl setText:@"2015年10月20日之前有效"];
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return cellHeight;
}

@end

