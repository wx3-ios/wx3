//
//  LMMoreSellerActivityCell.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMoreSellerActivityCell.h"

@interface LMMoreSellerActivityCell(){
    WXUILabel *numberLabel;
    WXUILabel *actiLabel1;
    WXUILabel *actiLabel2;
}
@end

@implementation LMMoreSellerActivityCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 50;
        CGFloat imgHeight = 38;
        WXUIImageView *bgImgView = [[WXUIImageView alloc] init];
        bgImgView.frame = CGRectMake(xOffset, (LMMoreSellerActivityCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [bgImgView setImage:[UIImage imageNamed:@"LMSellerInfoBgImg.png"]];
        [self.contentView addSubview:bgImgView];
        
        WXUIImageView *smImgView = [[WXUIImageView alloc] init];
        smImgView.frame = CGRectMake(1, 1, imgWidth-2, imgHeight-2);
        [smImgView setImage:[UIImage imageNamed:@"LMSellerInfoSmImg.png"]];
        [bgImgView addSubview:smImgView];
        
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, smImgView.frame.size.width, smImgView.frame.size.height/2);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"上新"];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setTextColor:WXColorWithInteger(0xffffff)];
        [textLabel setFont:WXFont(10.0)];
        [smImgView addSubview:textLabel];
        
        numberLabel = [[WXUILabel alloc] init];
        numberLabel.frame = CGRectMake(0, smImgView.frame.size.height/2, smImgView.frame.size.width, smImgView.frame.size.height/2);
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [numberLabel setTextColor:WXColorWithInteger(0x000000)];
        [numberLabel setFont:WXFont(12.0)];
        [smImgView addSubview:numberLabel];
        
        xOffset += imgWidth+6;
        CGFloat yOffset = 14;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 15;
        actiLabel1 = [[WXUILabel alloc] init];
        actiLabel1.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [actiLabel1 setBackgroundColor:[UIColor clearColor]];
        [actiLabel1 setTextAlignment:NSTextAlignmentLeft];
        [actiLabel1 setFont:WXFont(12.0)];
        [actiLabel1 setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:actiLabel1];
        
        yOffset += labelHeight;
        actiLabel2 = [[WXUILabel alloc] init];
        actiLabel2.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [actiLabel2 setBackgroundColor:[UIColor clearColor]];
        [actiLabel2 setTextAlignment:NSTextAlignmentLeft];
        [actiLabel2 setFont:WXFont(12.0)];
        [actiLabel2 setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:actiLabel2];
    }
    return self;
}

-(void)load{

}

@end
