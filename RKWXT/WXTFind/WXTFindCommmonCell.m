//
//  WXTFindCommmonCell.m
//  RKWXT
//
//  Created by SHB on 15/4/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTFindCommmonCell.h"

@interface WXTFindCommmonCell(){
}
@end

@implementation WXTFindCommmonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIImage *img = [UIImage imageNamed:@"FindShop.png"];
        
        CGSize size1 = [self sizeOfString:@"商家联盟" font:WXFont(12.0)];
        WXUIButton *bgImgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgImgBtn.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH/2, FindCommonCellHeight);
        [bgImgBtn setImage:[UIImage imageNamed:@"FindShop.png"] forState:UIControlStateNormal];
        [bgImgBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (IPHONE_SCREEN_WIDTH/2-img.size.width)/2, FindCommonCellHeight/2, 0)];
        [bgImgBtn setTitle:@"商家联盟" forState:UIControlStateNormal];
        [bgImgBtn setBorderRadian:0 width:0.2 color:[UIColor grayColor]];
        [bgImgBtn setTitleEdgeInsets:UIEdgeInsetsMake(FindCommonCellHeight/2, (IPHONE_SCREEN_WIDTH/2-size1.width)/4, 0, 0)];
        [bgImgBtn setTitleColor:WXColorWithInteger(0x646464) forState:UIControlStateNormal];
        [bgImgBtn.titleLabel setFont:WXFont(12.0)];
        [bgImgBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        bgImgBtn.tag = 1;
        [bgImgBtn addTarget:self action:@selector(gotoShopMertan:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bgImgBtn];
        
        
        WXUIButton *twoImgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        twoImgBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH/2+5, 0, IPHONE_SCREEN_WIDTH/4, FindCommonCellHeight);
        [twoImgBtn setImage:[UIImage imageNamed:@"FindJingdong.png"] forState:UIControlStateNormal];
        [twoImgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, FindCommonCellHeight/2, 0)];
        [twoImgBtn setTitle:@"京东" forState:UIControlStateNormal];
        [twoImgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, FindCommonCellHeight/2, 0, 0)];
        [twoImgBtn.titleLabel setTextColor:WXColorWithInteger(0x646464)];
        [twoImgBtn.titleLabel setFont:WXFont(12.0)];
        [twoImgBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        twoImgBtn.tag = 2;
        [twoImgBtn addTarget:self action:@selector(gotoShopMertan:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:twoImgBtn];
        
        WXUIButton *threeImgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        threeImgBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH*3/4+0.5, 0, IPHONE_SCREEN_WIDTH/2, FindCommonCellHeight);
        [threeImgBtn setImage:[UIImage imageNamed:@"FindTaobao.png"] forState:UIControlStateNormal];
        [threeImgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, FindCommonCellHeight/2, 0)];
        [threeImgBtn setTitle:@"淘宝网" forState:UIControlStateNormal];
        [threeImgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, FindCommonCellHeight/2, 0, 0)];
        threeImgBtn.tag = 3;
        [threeImgBtn addTarget:self action:@selector(gotoShopMertan:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:threeImgBtn];
    }
    return self;
}

-(void)load{
}

-(void)gotoShopMertan:(id)sender{
    WXUIButton *btn = sender;
    if(_delegate && [_delegate respondsToSelector:@selector(wxtFindCommonCellClicked:)]){
        [_delegate wxtFindCommonCellClicked:btn.tag];
    }
}

- (CGSize)sizeOfString:(NSString*)txt font:(UIFont*)font{
    if(!txt || [txt isKindOfClass:[NSNull class]]){
        txt = @" ";
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [txt sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [txt sizeWithFont:font];
    }
}

@end
