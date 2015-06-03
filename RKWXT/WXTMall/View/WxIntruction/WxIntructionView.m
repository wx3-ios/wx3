//
//  WxIntructionView.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WxIntructionView.h"
#import "NewHomePageCommonDef.h"
#import "WxIntructionCell.h"
#import "WXRemotionImgBtn.h"
//#import "T_HomePageTopNavEntity.h"

@interface WxIntructionView(){
    WXUILabel *_nameLabel;
    WXUILabel *_descLabel;
    WXRemotionImgBtn *_imgView;
}
@end

@implementation WxIntructionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat width = (IPHONE_SCREEN_WIDTH-3*xGap)/2;
        CGFloat height = T_HomePageWXIntructionHeight-yGap;
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0.5, width, height);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(wxIntruction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat xOffset = 10;
        CGFloat yOffset = 23;
        CGFloat textWidth = 60;
        CGFloat textHeight = 16;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:[UIFont systemFontOfSize:BigTextFont]];
        [_nameLabel setTextColor:WXColorWithInteger(BigTextColor)];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += textHeight+11;
        _descLabel = [[WXUILabel alloc] init];
        _descLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setFont:[UIFont systemFontOfSize:SmallTextFont]];
        [_descLabel setTextColor:WXColorWithInteger(SmallTextColor)];
        [bgBtn addSubview:_descLabel];
        
        xOffset += textWidth;
        CGFloat imgWidth = 62;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset+(width-xOffset-imgWidth)/2, (height-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self addSubview:_imgView];
    }
    return self;
}

-(void)wxIntruction:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[WxIntructionCell class]]);
    if(superView && [superView isKindOfClass:[WxIntructionCell class]]){
        WxIntructionCell *cell = (WxIntructionCell*)superView;
        id<wxIntructionCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(intructionClicked:)]){
            [delegate intructionClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
//    T_HomePageTopNavEntity *entity = self.cpxViewInfo;
//    [_nameLabel setText:entity.title];
//    [_descLabel setText:entity.content];
//    [_imgView setCpxViewInfo:entity.nav_img];
    [_nameLabel setText:@"我信介绍"];
    [_descLabel setText:@"企业简介"];
    [_imgView setCpxViewInfo:@"http://gz.67call.com/wx/Public/Uploads/20140929/20140929111809_9365271.jpeg"];
    [_imgView load];
}

@end
