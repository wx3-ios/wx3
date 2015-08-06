//
//  MakeOrderBananceSwitchCell.m
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderBananceSwitchCell.h"

@interface MakeOrderBananceSwitchCell(){
    WXUISwitch *_switch;
}
@end

@implementation MakeOrderBananceSwitchCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat width = 32;
        CGFloat height = 20;
        _switch = [[WXUISwitch alloc] init];
        _switch.frame = CGRectMake(IPHONE_SCREEN_WIDTH-30-width, 6, width, height);
        [_switch setOn:NO];
        [_switch addTarget:self action:@selector(swicthvalueChanged) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switch];
    }
    return self;
}

-(void)load{
    NSInteger on = [self.cellInfo integerValue];
    [_switch setOn:(on==1?YES:NO)];
}

-(void)swicthvalueChanged{
    if(_delegate && [_delegate respondsToSelector:@selector(balanceSwitchValueChanged)]){
        [_delegate balanceSwitchValueChanged];
    }
}

@end