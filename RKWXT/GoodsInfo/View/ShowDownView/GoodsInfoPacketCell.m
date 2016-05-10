//
//  GoodsInfoPacketCell.m
//  RKWXT
//
//  Created by SHB on 15/10/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "GoodsInfoPacketCell.h"
#import "GoodsInfoEntity.h"
#import "ShopActivityEntity.h"

@interface GoodsInfoPacketCell(){
    WXUIImageView *imgView1;
    WXUIImageView *imgView2;
    WXUILabel *label1;
    WXUILabel *label2;
}
@end

@implementation GoodsInfoPacketCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 10;
        CGFloat imgHeight = 12;
        imgView1 = [[WXUIImageView alloc] init];
        imgView1.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView1 setImage:[UIImage imageNamed:@"GoodsInfoRedImg.png"]];
        [self.contentView addSubview:imgView1];
        
        xOffset += imgWidth+3;
        CGFloat labelWidth = 45;
        CGFloat labelHeight = 18;
        label1 = [[WXUILabel alloc] init];
        label1.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setTextAlignment:NSTextAlignmentLeft];
        [label1 setText:@"使用红包"];
        [label1 setTextColor:WXColorWithInteger(0x000000)];
        [label1 setFont:WXFont(8.0)];
        [self.contentView addSubview:label1];
        
        xOffset += labelWidth+8;
        imgView2 = [[WXUIImageView alloc] init];
        imgView2.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView2 setImage:[UIImage imageNamed:@"GoodsInfoCutImg.png"]];
        [self.contentView addSubview:imgView2];
        
        xOffset += imgWidth+3;
        label2 = [[WXUILabel alloc] init];
        label2.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextAlignment:NSTextAlignmentLeft];
        [label2 setText:@"提成"];
        [label2 setTextColor:WXColorWithInteger(0x000000)];
        [label2 setFont:WXFont(8.0)];
        [self.contentView addSubview:label2];
        
        CGFloat btnWidth = 30;
        CGFloat btnHeight = 12;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-5-btnWidth, (GoodsInfoPacketCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:@"GoodsInfoDownImg.png"] forState:UIControlStateNormal];
        [btn setEnabled:NO];
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    GoodsInfoEntity *entity = self.cellInfo;
    if(entity.use_red && !entity.use_cut){
        [imgView2 setHidden:YES];
        [label2 setHidden:YES];
    }
    if(!entity.use_red && entity.use_cut){
        [imgView1 setHidden:YES];
        [label1 setHidden:YES];
        
        CGRect rect = imgView2.frame;
        rect.origin.x = 10;
        [imgView2 setFrame:rect];
        
        CGRect rect1 = label2.frame;
        rect1.origin.x = rect.origin.x+rect.size.width+4;
        [label2 setFrame:rect1];
    }
}



-(void)load{
}

@end
