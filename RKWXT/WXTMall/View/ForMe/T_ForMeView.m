//
//  T_ForMeView.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_ForMeView.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "T_ForMeCell.h"
#import "HomePageRecEntity.h"

@interface T_ForMeView(){
    WXUILabel *_nameLabel;
    WXUILabel *_desclabel;
    WXRemotionImgBtn *_imgView;
}
@end

@implementation T_ForMeView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat bgWidth = (IPHONE_SCREEN_WIDTH-4*xGap)/3;
        CGFloat bgHeight = T_HomePageForMeHeight;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, bgWidth, bgHeight);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(forMeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat xOffset = 5;
        CGFloat yOffset = 8;
        CGFloat width = bgWidth-2*xOffset;
        CGFloat height = 20;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, width, height);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(BigTextColor)];
        [_nameLabel setFont:[UIFont systemFontOfSize:BigTextFont]];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += height;
        height = 15;
        _desclabel = [[WXUILabel alloc] init];
        _desclabel.frame = CGRectMake(xOffset, yOffset, width, height);
        [_desclabel setBackgroundColor:[UIColor clearColor]];
        [_desclabel setTextAlignment:NSTextAlignmentLeft];
        [_desclabel setTextColor:WXColorWithInteger(SmallTextColor)];
        [_desclabel setFont:[UIFont systemFontOfSize:SmallTextFont]];
        [bgBtn addSubview:_desclabel];
        
        
        xOffset = 7;
        CGFloat imgWidth = bgWidth-2*xOffset;
        CGFloat imgHeight = imgWidth;
        yOffset = bgHeight-7-imgWidth+5;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
    }
    return self;
}

-(void)forMeBtnClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[T_ForMeCell class]]);
    if(superView && [superView isKindOfClass:[T_ForMeCell class]]){
        T_ForMeCell *cell = (T_ForMeCell*)superView;
        id<forMeCellDeleagte>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(forMeCellClicked:)]){
            [delegate forMeCellClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    HomePageRecEntity *entity = self.cpxViewInfo;
    [_nameLabel setText:entity.goods_name];
    [_desclabel setText:entity.goods_intro];
    [_imgView setCpxViewInfo:entity.home_img];
    [_imgView load];
}

@end
