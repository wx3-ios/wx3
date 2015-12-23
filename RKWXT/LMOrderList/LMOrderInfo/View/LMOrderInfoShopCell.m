//
//  LMOrderInfoShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoShopCell.h"
#import "LMOrderListEntity.h"

@interface LMOrderInfoShopCell(){
    WXUIImageView *imgView;
    WXUILabel *nameLabel;
}
@end

@implementation LMOrderInfoShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (LMOrderInfoShopCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"LMSellerIcon.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+5;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 20;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMOrderInfoShopCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [nameLabel setText:entity.shopName];
}

@end
