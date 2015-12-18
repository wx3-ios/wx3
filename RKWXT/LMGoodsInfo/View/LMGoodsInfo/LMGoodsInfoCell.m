//
//  LMGoodsInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsInfoCell.h"
#import "LMGoodsInfoEntity.h"

@interface LMGoodsInfoCell(){
    WXUILabel *nameLabel;
    WXUILabel *desLabel;
}
@end

@implementation LMGoodsInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat yOffset = 12;
        CGFloat labelHeight = 13;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH/3-xOffset, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x888888)];
        [nameLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:nameLabel];
        
        desLabel = [[WXUILabel alloc] init];
        desLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH/3, yOffset, IPHONE_SCREEN_WIDTH*2/3-xOffset, labelHeight);
        [desLabel setBackgroundColor:[UIColor clearColor]];
        [desLabel setTextAlignment:NSTextAlignmentRight];
        [desLabel setTextColor:WXColorWithInteger(0x888888)];
        [desLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:desLabel];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset, yOffset+labelHeight+1, IPHONE_SCREEN_WIDTH-2*xOffset, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:lineLabel];
    }
    return self;
}

-(void)load{
    LMGoodsInfoEntity *entity = self.cellInfo;
    [nameLabel setText:entity.attrName];
    [desLabel setText:entity.attrValue];
}

@end
