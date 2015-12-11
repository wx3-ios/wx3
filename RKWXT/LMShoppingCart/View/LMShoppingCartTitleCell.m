//
//  LMShoppingCartTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShoppingCartTitleCell.h"
#import "WXRemotionImgBtn.h"

@interface LMShoppingCartTitleCell(){
    WXUIButton *selBtn;
    WXRemotionImgBtn *imgView;
    WXUILabel *sellerName;
    WXUIImageView *arrowImg;
    WXUIButton *editBtn;
    
    BOOL editing;
}
@end

@implementation LMShoppingCartTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 8;
        CGFloat selBtnWidth = 18;
        CGFloat selBtnHeight = selBtnWidth;
        
//        if(select){
//            [_circleBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
//        }else{
//            [_circleBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
//        }
        selBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        selBtn.frame = CGRectMake(xOffset, (LMShoppingCartTitleCellHieght-selBtnHeight)/2, selBtnWidth, selBtnHeight);
        [selBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
        [selBtn addTarget:self action:@selector(clrcleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selBtn];
        
        xOffset += selBtnWidth+5;
        CGFloat imgWidth = 34;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMShoppingCartTitleCellHieght-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+3;
        CGFloat nameLabelHeight = 20;
        CGFloat nameLabelWidth = 20;
        sellerName = [[WXUILabel alloc] init];
        sellerName.frame = CGRectMake(xOffset, (LMShoppingCartTitleCellHieght-nameLabelHeight)/2, nameLabelWidth, nameLabelHeight);
        [sellerName setBackgroundColor:[UIColor clearColor]];
        [sellerName setTextAlignment:NSTextAlignmentLeft];
        [sellerName setTextColor:WXColorWithInteger(0x000000)];
        [sellerName setFont:WXFont(15.0)];
        [self.contentView addSubview:sellerName];
        
        xOffset += nameLabelWidth+3;
        CGFloat arrowWidth = 11;
        CGFloat arrowHeight = 16;
        arrowImg = [[WXUIImageView alloc] init];
        arrowImg.frame = CGRectMake(xOffset, (LMShoppingCartTitleCellHieght-arrowHeight)/2, arrowWidth, arrowHeight);
        [arrowImg setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:arrowImg];
        
        CGFloat xGap = 46;
        CGFloat lineHeight = 18;
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMShoppingCartTitleCellHieght-lineHeight)/2, 0.5, lineHeight);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:lineLabel];
        
        CGFloat editBtnHeight = 20;
        editBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMShoppingCartTitleCellHieght-editBtnHeight)/2, xGap, editBtnHeight);
        [editBtn setBackgroundColor:[UIColor clearColor]];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:WXColorWithInteger(0xefeff4) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
    }
    return self;
}

-(void)load{
    
}

-(void)clrcleBtnClicked{
    if(editing){
        editing = NO;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }else{
        editing = YES;
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
}

-(void)editBtnClicked{
    
}

@end
