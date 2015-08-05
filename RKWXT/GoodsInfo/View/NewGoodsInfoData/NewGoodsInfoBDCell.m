//
//  NewGoodsInfoBDCell.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoBDCell.h"
#import "GoodsInfoDef.h"

#define xOffset (15)
#define imgWidth (7)
#define imgHeight (11)

@interface NewGoodsInfoBDCell(){
    WXUIImageView *_imgView;
}
@end

@implementation NewGoodsInfoBDCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _imgView = [[WXUIImageView alloc] init];
        _imgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-imgWidth, (T_GoodsInfoOldBDCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [_imgView setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:_imgView];
    }
    return self;
}


-(void)changeArrowWithDown:(BOOL)down{
    if (down) {
        _imgView.image = [UIImage imageNamed:@"T_ArrowDown.png"];
        _imgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-imgWidth-4, (T_GoodsInfoOldBDCellHeight-imgHeight)/2, imgHeight, imgWidth);
    }else{
        _imgView.image = [UIImage imageNamed:@"T_ArrowRight.png"];
        _imgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-imgWidth, (T_GoodsInfoOldBDCellHeight-imgHeight)/2, imgWidth, imgHeight);
    }
}

@end
