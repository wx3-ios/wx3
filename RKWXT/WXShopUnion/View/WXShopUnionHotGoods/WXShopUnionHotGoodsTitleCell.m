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
        [textLabel setTextColor:WXColorWithInteger(0x595757)];
        [textLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    
}

@end
