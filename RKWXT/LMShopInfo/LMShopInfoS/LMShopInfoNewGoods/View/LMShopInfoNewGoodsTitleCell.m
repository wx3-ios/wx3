//
//  LMShopInfoNewGoodsTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoNewGoodsTitleCell.h"

@interface LMShopInfoNewGoodsTitleCell(){
    WXUILabel *titleName;
}
@end

@implementation LMShopInfoNewGoodsTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat yOffset = 15;
        CGFloat width = 90;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(0, yOffset, width, LMShopInfoNewGoodsTitleCellHeight-yOffset);
        [imgView setImage:[UIImage imageNamed:@"LMShopInfoNewGoodsTitleImg.png"]];
        [self.contentView addSubview:imgView];
        
        titleName = [[WXUILabel alloc] init];
        titleName.frame = CGRectMake(0, 0, width-3, imgView.frame.size.height);
        [titleName setBackgroundColor:[UIColor clearColor]];
        [titleName setTextAlignment:NSTextAlignmentCenter];
        [titleName setTextColor:WXColorWithInteger(0xffffff)];
        [titleName setFont:WXFont(15.0)];
        [imgView addSubview:titleName];
    }
    return self;
}

-(void)load{
    
}

@end
