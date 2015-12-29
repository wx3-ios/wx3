//
//  WXShopUnionHotGoodsTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionHotGoodsTitleCell.h"
#import "WXShopUnionDef.h"

@implementation WXShopUnionHotGoodsTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 100;
        CGFloat labelHight = 15;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (ShopUnionHotGoodsTextHeight-labelHight)/2, labelWidth, labelHight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"热门商品"];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x323232)];
        [textLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:textLabel];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(0, ShopUnionHotGoodsTextHeight-0.5, IPHONE_SCREEN_WIDTH, 0.5);
        [lineLabel setBackgroundColor:WXColorWithInteger(0xefeff3)];
        [self.contentView addSubview:lineLabel];
    }
    return self;
}

-(void)load{
    
}

@end
