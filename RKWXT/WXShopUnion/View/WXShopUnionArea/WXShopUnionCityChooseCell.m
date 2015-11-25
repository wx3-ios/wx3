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
        CGFloat namelabelWidth = 80;
        CGFloat nameLabelHeight = 25;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-nameLabelHeight)/2, namelabelWidth, nameLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
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
    }
    return self;
}

-(void)load{
    [cityLabel setText:@"深圳"];
}

@end
