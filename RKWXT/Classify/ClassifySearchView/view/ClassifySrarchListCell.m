//
//  ClassifySrarchListCell.m
//  RKWXT
//
//  Created by SHB on 15/10/20.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifySrarchListCell.h"
#import "SearchResultEntity.h"

@interface ClassifySrarchListCell(){
    WXUILabel *nameLabel;
}
@end

@implementation ClassifySrarchListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 180;
        CGFloat labelHeight = 25;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x606062)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    SearchResultEntity *entity = self.cellInfo;
    if([entity isKindOfClass:[NSString class]]){
        [nameLabel setText:AlertName];
        [nameLabel setFont:WXFont(12.0)];
        [nameLabel setTextColor:[UIColor grayColor]];
    }else{
        [nameLabel setText:entity.goodsName];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setTextColor:WXColorWithInteger(0x606062)];
    }
}

@end
