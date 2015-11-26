//
//  WXShopUnionCityChooseCell.m
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionCityChooseCell.h"

@interface WXShopUnionCityChooseCell(){
    WXUILabel *cityLabel;
}
@end

@implementation WXShopUnionCityChooseCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat namelabelWidth = 70;
        CGFloat nameLabelHeight = 25;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-nameLabelHeight)/2, namelabelWidth, nameLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setText:@"当前城市："];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += namelabelWidth;
        cityLabel = [[WXUILabel alloc] init];
        cityLabel.frame = CGRectMake(xOffset, (44-nameLabelHeight)/2, 150, nameLabelHeight);
        [cityLabel setBackgroundColor:[UIColor clearColor]];
        [cityLabel setTextAlignment:NSTextAlignmentLeft];
        [cityLabel setTextColor:WXColorWithInteger(0x000000)];
        [cityLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:cityLabel];
        
        CGFloat changeLabelWidth = 50;
        WXUILabel *changeLabel = [[WXUILabel alloc] init];
        changeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-changeLabelWidth-26, (44-nameLabelHeight)/2, changeLabelWidth, nameLabelHeight);
        [changeLabel setBackgroundColor:[UIColor clearColor]];
        [changeLabel setText:@"更换"];
        [changeLabel setTextAlignment:NSTextAlignmentRight];
        [changeLabel setTextColor:[UIColor colorWithRed:0.961 green:0.025 blue:0.048 alpha:1.000]];
        [changeLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:changeLabel];
    }
    return self;
}

-(void)load{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [cityLabel setText:userObj.userCurrentCity];
}

@end
