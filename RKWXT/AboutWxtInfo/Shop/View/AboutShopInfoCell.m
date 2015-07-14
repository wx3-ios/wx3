//
//  AboutShopInfoCell.m
//  Woxin2.0
//
//  Created by qq on 14-8-18.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "AboutShopInfoCell.h"
#import "AboutShopEntity.h"
#import "NSString+HTML.h"

@interface AboutShopInfoCell (){
    WXUILabel *_description;
    WXUILabel *_shopName;
    WXUILabel *_telLabel;
    WXUILabel *_Phone;
    WXUILabel *_address;
}

@end

@implementation AboutShopInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 8;
        CGFloat yOffset = 0;
        CGFloat desWidth = IPHONE_SCREEN_WIDTH-2*xOffset;
        _description = [[WXUILabel alloc] init];
        _description.frame = CGRectMake(xOffset, yOffset+5, desWidth, 0);
        [_description setBackgroundColor:[UIColor clearColor]];
        [_description setFont:[UIFont systemFontOfSize:14.0]];
        [_description setTextColor:WXColorWithInteger(0x646464)];
        [_description setNumberOfLines:0];
        
        yOffset = 6;
        CGFloat nameHeight = 17;
        _shopName = [[WXUILabel alloc] init];
        _shopName.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, nameHeight);
        [_shopName setBackgroundColor:[UIColor clearColor]];
        [_shopName setTextAlignment:NSTextAlignmentLeft];
        [_shopName setFont:[UIFont systemFontOfSize:14.0]];
        [_shopName setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:_shopName];
        
        yOffset += nameHeight+5;
        CGFloat telLabelWidth = 65;
        _telLabel = [[WXUILabel alloc] init];
        _telLabel.frame = CGRectMake(xOffset, yOffset, telLabelWidth, nameHeight);
        [_telLabel setBackgroundColor:[UIColor clearColor]];
        [_telLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_telLabel setTextColor:WXColorWithInteger(0x646464)];
        [_telLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_telLabel];
        
        
        CGFloat xGap = xOffset+telLabelWidth;
        _Phone = [[WXUILabel alloc] init];
        _Phone.frame = CGRectMake(xGap, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, nameHeight);
        [_Phone setBackgroundColor:[UIColor clearColor]];
        [_Phone setTextAlignment:NSTextAlignmentLeft];
        [_Phone setFont:[UIFont systemFontOfSize:14.0]];
        [_Phone setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:_Phone];
        
        
        yOffset += nameHeight+5;
        _address = [[WXUILabel alloc] init];
        _address.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, 0);
        [_address setBackgroundColor:[UIColor clearColor]];
        [_address setFont:[UIFont systemFontOfSize:14.0]];
        [_address setTextAlignment:NSTextAlignmentLeft];
        [_address setTextColor:WXColorWithInteger(0x646464)];
        [_address setNumberOfLines:0];
        [self.contentView addSubview:_address];
    }
    return self;
}

-(void)load{
    AboutShopEntity *entity = self.cellInfo;
    NSString *address = [NSString stringWithFormat:@"分店地址:  %@",entity.address];
    CGFloat height = [address stringHeight:[UIFont systemFontOfSize:14.0] width:IPHONE_SCREEN_WIDTH-16];
    [_shopName setText:kMerchantName];
    [_telLabel setText:@"联系电话:"];
    [_Phone setText:[NSString stringWithFormat:@"%@",entity.tel]];
    [_address setText:address];
    
    CGRect rect = _address.frame;
    rect.size.height = height;
    [_address setFrame:rect];
}

-(void)loadAboutShopInfoDescription:(NSString *)desc{
    NSString *newStr = [desc stringByConvertingHTMLToPlainText];
    CGFloat height = [newStr stringHeight:[UIFont systemFontOfSize:14.0] width:IPHONE_SCREEN_WIDTH-16];
    [_description setText:newStr];
    [self.contentView addSubview:_description];
    
    CGRect rect = _description.frame;
    rect.size.height = height;
    [_description setFrame:rect];
}

@end
