//
//  LMShopInfoActivityCell.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoActivityCell.h"
#import "WXRemotionImgBtn.h"
#import "LMShopInfoDef.h"

@interface LMShopInfoActivityCell(){
    WXRemotionImgBtn *imgView;
}
@end

@implementation LMShopInfoActivityCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
//        CGFloat xOffset = 10;
//        CGFloat yOffset = 10;
//        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, LMShopInfoActivityHeight-2*yOffset)];
//        [imgView setUserInteractionEnabled:NO];
//        [self.contentView addSubview:imgView];
    }
    return self;
}

-(void)load{
    
}

@end
