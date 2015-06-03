//
//  T_TopicalView.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_TopicalView.h"
#import "NewHomePageCommonDef.h"
#import "WXRemotionImgBtn.h"
#import "T_TopicalCell.h"
//#import "T_HomePageThmEntity.h"

@interface T_TopicalView(){
    WXUILabel *_nameLabel;
    WXUILabel *_descLabel;
    WXRemotionImgBtn *_imgView;
}
@end

@implementation T_TopicalView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        WXUIButton *bgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, (IPHONE_SCREEN_WIDTH-3*xGap)/2, T_HomePageTopicalHeight-yGap);
        [bgBtn setBackgroundColor:[UIColor whiteColor]];
        [bgBtn addTarget:self action:@selector(wxIntruction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        CGFloat xOffset = 6;
        CGFloat yOffset = 12;
        CGFloat textWidth = 60;
        CGFloat textHeight = 16;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:[UIFont systemFontOfSize:BigTextFont]];
        [_nameLabel setTextColor:WXColorWithInteger(BigTextColor)];
        [bgBtn addSubview:_nameLabel];
        
        yOffset += textHeight+10;
        _descLabel = [[WXUILabel alloc] init];
        _descLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setFont:[UIFont systemFontOfSize:SmallTextFont]];
        [_descLabel setTextColor:WXColorWithInteger(SmallTextColor)];
        [bgBtn addSubview:_descLabel];
        
        xOffset += textWidth+20;
        CGFloat imgWidth = 50;
        CGFloat imgHeight = 50;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (T_HomePageTopicalHeight-yGap-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [bgBtn addSubview:_imgView];
    }
    return self;
}

-(void)wxIntruction:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[T_TopicalCell class]]);
    if(superView && [superView isKindOfClass:[T_TopicalCell class]]){
        T_TopicalCell *cell = (T_TopicalCell*)superView;
        id<TopicalCellDeleagte>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(topicalCellClicked:)]){
            [delegate topicalCellClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
//    T_HomePageThmEntity *entity = self.cpxViewInfo;
//    [_nameLabel setText:entity.cat_name];
//    [_descLabel setText:entity.cat_intro];
    [_descLabel setText:@"暂无内容"];
//    [_imgView setCpxViewInfo:entity.category_img];
    [_imgView setCpxViewInfo:@"http://gz.67call.com/wx/Public/Uploads/20140929/20140929111809_9365271.jpeg"];
    [_imgView load];
}

@end
