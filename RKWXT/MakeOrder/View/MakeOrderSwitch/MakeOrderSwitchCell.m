//
//  MakeOrderSwitchCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderSwitchCell.h"
#import "MakeOrderDef.h"

@interface MakeOrderSwitchCell(){
    WXUISwitch *_switch;
}
@end

@implementation MakeOrderSwitchCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat width = 32;
        CGFloat height = 20;
        _switch = [[WXUISwitch alloc] init];
        _switch.frame = CGRectMake(IPHONE_SCREEN_WIDTH-30-width, 6, width, height);
        [_switch setOn:NO];
        [_switch addTarget:self action:@selector(swicthvalueChange) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switch];
    }
    return self;
}

-(void)load{
    NSInteger on = [self.cellInfo integerValue];
    [_switch setOn:(on==1?YES:NO)];
}

-(void)swicthvalueChange{
    if(_delegate && [_delegate respondsToSelector:@selector(switchValueChanged)]){
        [_delegate switchValueChanged];
    }
}
- (void)shutDownSwitch{
    _switch.onTintColor = [UIColor grayColor];
    _switch.userInteractionEnabled = NO;
}

@end
