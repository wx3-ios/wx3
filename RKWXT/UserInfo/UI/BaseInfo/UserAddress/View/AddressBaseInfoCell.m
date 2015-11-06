//
//  AddressBaseInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AddressBaseInfoCell.h"
#import "AreaEntity.h"

#define Ygap (17+16+20+20)

@interface AddressBaseInfoCell(){
    UILabel *_namelabel;
    UILabel *_userPhone;
    UILabel *_address;
}
@end

@implementation AddressBaseInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat yOffset = 17;
        CGFloat xOffset = 10;
        CGFloat nameWidth = 85;
        CGFloat nameHeight = 20;
        _namelabel = [[UILabel alloc] init];
        _namelabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_namelabel setBackgroundColor:[UIColor clearColor]];
        [_namelabel setTextAlignment:NSTextAlignmentLeft];
        [_namelabel setFont:WXFont(15.0)];
        [_namelabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:_namelabel];
        
        xOffset += nameWidth+15;
        _userPhone = [[UILabel alloc] init];
        _userPhone.frame = CGRectMake(xOffset, yOffset, nameWidth+20, nameHeight);
        [_userPhone setBackgroundColor:[UIColor clearColor]];
        [_userPhone setTextAlignment:NSTextAlignmentLeft];
        [_userPhone setTextColor:WXColorWithInteger(0x000000)];
        [_userPhone setFont:WXFont(15.0)];
        [self.contentView addSubview:_userPhone];
        
        xOffset = 10;
        yOffset += nameHeight+16;
        _address = [[UILabel alloc] init];
        _address.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width-2*xOffset, 10);
        [_address setBackgroundColor:[UIColor clearColor]];
        [_address setTextAlignment:NSTextAlignmentLeft];
        [_address setTextColor:WXColorWithInteger(0x8a8a8a)];
        [_address setNumberOfLines:0];
        [_address setFont:WXFont(15.0)];
        [self.contentView addSubview:_address];
    }
    return self;
}

-(void)load{
    AreaEntity *entity = self.cellInfo;
    [_namelabel setText:entity.userName];
    [_userPhone setText:entity.userPhone];
    [_address setText:[NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address]];
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    CGFloat height = 0.0;
    AreaEntity *entity = cellInfo;
    height = Ygap+[[self class] addressHeight:[NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address]];
    return height;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    AreaEntity *entity = self.cellInfo;
    CGFloat addHeight = [[self class] addressHeight:[NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address]];
    CGRect rect = _address.frame;
    rect.size.height = addHeight;
    [_address setFrame:rect];
}

+(CGFloat)addressHeight:(NSString*)address{
    CGFloat height = [address stringHeight:WXFont(15.0) width:IPHONE_SCREEN_WIDTH-2*5];
    return height;
}

@end
