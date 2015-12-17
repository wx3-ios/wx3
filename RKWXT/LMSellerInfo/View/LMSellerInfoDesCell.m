//
//  LMSellerInfoDesCell.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerInfoDesCell.h"
#import "LMSellerInfoEntity.h"

@interface LMSellerInfoDesCell(){
    WXUILabel *nameLabel;
    WXUILabel *desLabel;
}
@end

@implementation LMSellerInfoDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelHeight = 20;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, nameLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        yOffset += nameLabelHeight+10;
        CGFloat rightBtnWidth = 53;
        desLabel = [[WXUILabel alloc] init];
        desLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-rightBtnWidth-5, 41);
        [desLabel setBackgroundColor:[UIColor clearColor]];
        [desLabel setTextAlignment:NSTextAlignmentLeft];
        [desLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [desLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:desLabel];
        
        xOffset = IPHONE_SCREEN_WIDTH-rightBtnWidth-4;
        CGFloat lineHeight = 45;
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset, (LMSellerInfoDesCellHeight-lineHeight)/2, 0.5, lineHeight);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:lineLabel];
        
        CGFloat callBtnWidth = 35;
        CGFloat callBtnHeight = callBtnWidth;
        WXUIButton *callBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(xOffset+(rightBtnWidth-callBtnWidth)/2, (LMSellerInfoDesCellHeight-callBtnHeight)/2, callBtnWidth, callBtnHeight);
        [callBtn setBackgroundColor:[UIColor clearColor]];
        [callBtn setImage:[UIImage imageNamed:@"ContactInfoCall.png"] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callSellerPhone) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callBtn];
    }
    return self;
}

-(void)load{
    LMSellerInfoEntity *entity = self.cellInfo;
    [nameLabel setText:entity.sellerName];
    [desLabel setText:entity.address];
}

-(void)callSellerPhone{
    LMSellerInfoEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(lmShopInfoDesCallBtnClicked:)]){
        [_delegate lmShopInfoDesCallBtnClicked:entity.sellerPhone];
    }
}

@end
