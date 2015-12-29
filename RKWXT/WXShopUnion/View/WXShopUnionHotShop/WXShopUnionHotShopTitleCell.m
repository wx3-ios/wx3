//
//  WXShopUnionHotShopTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionHotShopTitleCell.h"
#import "WXShopUnionDef.h"

@implementation WXShopUnionHotShopTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat textWidth = 60;
        CGFloat textHeight = 15;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (ShopUnionHotShopTextHeight-textHeight)/2, textWidth, textHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"热门商家"];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x323232)];
        [textLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:textLabel];
        
        CGFloat btnWidth = 80;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-20-btnWidth, (ShopUnionHotShopTextHeight-textHeight)/2, btnWidth, textHeight);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:@"更多热门商家" forState:UIControlStateNormal];
        [btn.titleLabel setFont:WXFont(11.0)];
        [btn setTitleColor:WXColorWithInteger(0x9b9b9b) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(toSearchMoreHotShop) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(0, ShopUnionHotGoodsTextHeight-0.5, IPHONE_SCREEN_WIDTH, 0.5);
        [lineLabel setBackgroundColor:WXColorWithInteger(0xefeff3)];
        [self.contentView addSubview:lineLabel];
    }
    return self;
}

-(void)load{
    
}

-(void)toSearchMoreHotShop{
    if(_delegate && [_delegate respondsToSelector:@selector(shopUnionHotShopTitleClicked)]){
        [_delegate shopUnionHotShopTitleClicked];
    }
}

@end
