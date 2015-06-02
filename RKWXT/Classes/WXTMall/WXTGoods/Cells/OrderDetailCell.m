//
//  OrderDetailCell.m
//  RKWXT
//
//  Created by app on 6/2/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "OrderDetailCell.h"

@interface OrderDetailCell(){
}

@end

@implementation OrderDetailCell
@synthesize orderDetailStyle = _orderDetailStyle;
- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (_orderDetailStyle == OrderDetailDefaultCell) {
            [self setDefaultFrame];
        }else if (_orderDetailStyle == OrderDetailSwitchCell){
            [self setSwitchFrame];
        }
    }
    return self;
}

-(void)setDefaultFrame{
    _defaultTitleKey = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, 100, 18)];
    _defaultTitleKey.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_defaultTitleKey];
    
    _defaultTitleValue = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-54-13, 15,64, 18)];
    _defaultTitleValue.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_defaultTitleValue];
}

-(void)setSwitchFrame{
    _defaultTitleKey = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, 100, 18)];
    _defaultTitleKey.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_defaultTitleKey];
    
    UISwitch * switchOption = [[UISwitch alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-54-13, 8, 49, 32)];
    [self.contentView addSubview:switchOption];
}

-(NSInteger)orderDetailStyle{
    return _orderDetailStyle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
