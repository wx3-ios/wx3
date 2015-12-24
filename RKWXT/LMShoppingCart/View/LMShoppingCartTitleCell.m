//
//  LMShoppingCartTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShoppingCartTitleCell.h"
#import "LMShoppingCartEntity.h"

@interface LMShoppingCartTitleCell(){
    WXUIButton *selBtn;
    WXUILabel *sellerName;
    WXUIImageView *arrowImg;
    WXUIButton *editBtn;
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
        
        xOffset += selBtnWidth+10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] initWithFrame:CGRectMake(xOffset, (LMShoppingCartTitleCellHieght-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setImage:[UIImage imageNamed:@"LMSellerIcon.png"]];
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
        [lineLabel setBackgroundColor:WXColorWithInteger(0x9b9b9b)];
        [self.contentView addSubview:lineLabel];
        
        CGFloat editBtnHeight = 20;
        editBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMShoppingCartTitleCellHieght-editBtnHeight)/2, xGap, editBtnHeight);
        [editBtn setBackgroundColor:[UIColor clearColor]];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:WXFont(14.0)];
        [editBtn setTitleColor:WXColorWithInteger(0x9b9b9b) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
    }
    return self;
}

-(void)load{
    LMShoppingCartEntity *entity = self.cellInfo;
    [sellerName setText:entity.shopName];
    
    CGRect rect = sellerName.frame;
    rect.size.width = [NSString widthForString:entity.shopName fontSize:15.0 andHeight:20];
    [sellerName setFrame:rect];
    
    CGRect rect1 = arrowImg.frame;
    rect1.origin.x = rect.size.width+rect.origin.x+10;
    [arrowImg setFrame:rect1];
    
    if(entity.selectAll){
        [selBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        [selBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }
    
    if(entity.edit){
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    if(!entity.edit){
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

-(void)clrcleBtnClicked{
    LMShoppingCartEntity *entity = self.cellInfo;
    if(entity.selectAll){
        entity.selectAll = NO;
        [selBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }else{
        entity.selectAll = YES;
        [selBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(lmShoppingCartTitleCellCircleClicked:)]){
        [_delegate lmShoppingCartTitleCellCircleClicked:entity];
    }
}

-(void)editBtnClicked{
    LMShoppingCartEntity *entity = self.cellInfo;
    if(entity.edit){
        entity.edit = NO;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }else{
        entity.edit = YES;
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(lmShoppingCartTitleCellEditClicked:)]){
        [_delegate lmShoppingCartTitleCellEditClicked:entity];
    }
}

@end
