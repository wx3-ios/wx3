//
//  T_ChangeTitleCell.m
//  Woxin3.0
//
//  Created by SHB on 15/1/17.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_ChangeTitleCell.h"
#import "NewHomePageCommonDef.h"

@implementation T_ChangeTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = xGap+3;
        CGFloat yOffset = 5;
        CGFloat textWidth = 70;
        CGFloat textHeight = 20;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset+12, yOffset, textWidth, textHeight);
        [textLabel setText:@"更多惊喜"];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setFont:[UIFont systemFontOfSize:TextFont]];
        [textLabel setTextColor:WXColorWithInteger(BigTextColor)];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:textLabel];
        
        yOffset += 2;
        CGFloat btnWidth = 60;
        CGFloat btnHeight = 17;
        WXUIButton *changeBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth-xGap-3, yOffset, btnWidth, btnHeight);
        [changeBtn setBackgroundColor:[UIColor clearColor]];
        [changeBtn setImage:[UIImage imageNamed:@"HomePageChange.png"] forState:UIControlStateNormal];
        [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        [changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
        [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [changeBtn setTitleColor:WXColorWithInteger(0xcfcfcf) forState:UIControlStateNormal];
        [changeBtn.titleLabel setFont:WXFont(12.0)];
        [changeBtn addTarget:self action:@selector(changeOtherArray) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:changeBtn];
        
//        WXUILabel *label = [[WXUILabel alloc] init];
//        label.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth-xGap-3-45+17, yOffset, 40, btnHeight);
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setFont:WXFont(12.0)];
//        [label setTextColor:[UIColor grayColor]];
//        [label setTextAlignment:NSTextAlignmentCenter];
//        [label setText:@"换一组"];
//        [self.contentView addSubview:label];
    }
    return self;
}

-(void)changeOtherArray{
    if(_delegate && [_delegate respondsToSelector:@selector(changeOtherBtnClicked)]){
        [_delegate changeOtherBtnClicked];
    }
}

@end
