//
//  LMShopCollectionTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopCollectionTitleCell.h"
#import "WXRemotionImgBtn.h"
#import "LMShopCollectionEntity.h"

@interface LMShopCollectionTitleCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *namelabel;
    WXUILabel *scoreLabel;
}
@end

@implementation LMShopCollectionTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 35;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMShopCollectionTitleCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth;
        CGFloat yOffset = 5;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 18;
        namelabel = [[WXUILabel alloc] init];
        namelabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [namelabel setBackgroundColor:[UIColor clearColor]];
        [namelabel setTextAlignment:NSTextAlignmentLeft];
        [namelabel setTextColor:WXColorWithInteger(0x000000)];
        [namelabel setFont:WXFont(14.0)];
        [self.contentView addSubview:namelabel];
        
        yOffset += labelHeight+4;
        CGFloat width = 30;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, yOffset, width, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"评分"];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [textLabel setFont:WXFont(10.0)];
        [self.contentView addSubview:textLabel];

        xOffset += width;
        scoreLabel = [[WXUILabel alloc] init];
        scoreLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [scoreLabel setBackgroundColor:[UIColor clearColor]];
        [scoreLabel setTextAlignment:NSTextAlignmentLeft];
        [scoreLabel setTextColor:WXColorWithInteger(0xff9c00)];
        [scoreLabel setFont:WXFont(10.0)];
        [self.contentView addSubview:scoreLabel];
    }
    return self;
}

-(void)load{
    LMShopCollectionEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.homeImg];
    [namelabel setText:entity.shopName];
    [scoreLabel setText:[NSString stringWithFormat:@"%.2f",entity.score]];
}

@end
