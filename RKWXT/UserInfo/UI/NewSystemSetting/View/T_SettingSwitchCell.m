//
//  T_SettingSwitchCell.m
//  RKWXT
//
//  Created by SHB on 15/6/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_SettingSwitchCell.h"

@interface T_SettingSwitchCell(){
    WXUISwitch *_switch;
}
@end

@implementation T_SettingSwitchCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 25;
        CGFloat width = 30;
        CGFloat height = 28;
        _switch = [[WXUISwitch alloc] init];
        _switch.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-width, (44-height)/2, width, height);
        [_switch addTarget:self action:@selector(keyPadTone:) forControlEvents:UIControlEventValueChanged];
        [_switch setOnTintColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_switch];
    }
    return self;
}

-(void)setSwitchIsOn:(BOOL)on{
    [_switch setOn:on];
}

-(void)keyPadTone:(WXUISwitch*)s{
    if(_delegate && [_delegate respondsToSelector:@selector(keyPadToneSetting:)]){
        [_delegate keyPadToneSetting:_switch];
    }
}

@end
