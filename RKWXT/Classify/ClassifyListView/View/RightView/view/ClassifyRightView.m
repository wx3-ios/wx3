//
//  ClassifyRightView.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyRightView.h"
#import "ClassifyRightDef.h"
#import "WXRemotionImgBtn.h"
#import "ClassifyRightCell.h"

@interface ClassifyRightView(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
}
@end

@implementation ClassifyRightView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-ClassifyLeftViewWidth-4*xGap)/3;
        CGFloat bgHeight = EveryCellHeight-15;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 15, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:WXColorWithInteger(0xffffff)];
        [bgBtn addTarget:self action:@selector(bgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat xOffset = 7;
        CGFloat imgWidth = bgWidth-2*xOffset;
        CGFloat imgHeight = imgWidth;
        CGFloat yOffset = xOffset;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
        
        yOffset += imgHeight+8;
        CGFloat width = bgWidth-2*xOffset;
        CGFloat height = 20;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, width, height);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(11.0)];
        [bgBtn addSubview:_nameLabel];
    }
    return self;
}

-(void)bgBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[ClassifyRightCell class]]);
    if(superView && [superView isKindOfClass:[ClassifyRightCell class]]){
        ClassifyRightCell *cell = (ClassifyRightCell*)superView;
        id<ClassifyRightCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(goodsListCellClicked:)]){
            [delegate goodsListCellClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    NSDictionary *dic = self.cpxViewInfo;
    BOOL isGoods = NO;
    for(NSString *key in [dic allKeys]){
        if([key isEqualToString:@"goods_id"]){
            isGoods = YES;
        }
    }
    if(isGoods){
        [_nameLabel setText:[dic objectForKey:@"goods_name"]];
        [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,[dic objectForKey:@"goods_home_img"]]];
        [_imgView load];
    }else{
        [_nameLabel setText:[dic objectForKey:@"cat_name"]];
        [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,[dic objectForKey:@"cat_img"]]];
        [_imgView load];
    }
}

@end
