//
//  SysMsgBodyCell.m
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgCell.h"
#import "SysMsgItem.h"
#import "WXRemotionImgBtn.h"
#import "SysMsgToDetailTipView.h"

#define kXGap (7.0)
#define kYGap (15.0)
#define kMessageBodyWidth (IPHONE_SCREEN_WIDTH - kSysMessageBorderXGap*2 - kXGap*2)
#define kImageHeight (kMessageBodyWidth*0.5)
#define kYBigGap (20.0)
#define kTitleFontSize (14.0)
#define kAbstractFontSize (12.0)
@interface SysMsgCell()
{
    WXUILabel *_titleLabel;
    WXRemotionImgBtn *_remotionImgView;
    WXUILabel *_abstractLabel;
	SysMsgToDetailTipView *_tipView;
}
@end

@implementation SysMsgCell

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = kXGap;
        CGFloat yoffset = kYGap;
		[self setBackgroundColor:[UIColor clearColor]];
		
		CGRect rect = self.bounds;
//		rect.origin.x = kSysMessageTableViewXGap;
//		rect.size.width = rect.size.width - kSysMessageTableViewXGap*2;
		WXUIView *borderView = [[WXUIView alloc] initWithFrame:rect];
		[borderView setBackgroundColor:[UIColor whiteColor]];
		[borderView setAutoresizingMask:kUIViewAutoresizingFlexibleAll];
		[borderView setBorderRadian:10.0 width:0.5 color:WXColorWithInteger(0xd2d2d2)];
		[self.contentView addSubview:borderView];
		
        UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGFloat titleHeight = [[self class] titleHeight];
        _titleLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(xOffset, yoffset, kMessageBodyWidth, titleHeight)];
        [_titleLabel setFont:WXFont(kTitleFontSize)];
        [_titleLabel setTextColor:WXColorWithInteger(0x323232)];
        [_titleLabel setAutoresizingMask:autoresizingMask];
        [borderView addSubview:_titleLabel];
        
        yoffset += titleHeight + kYGap;
        _remotionImgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yoffset, kMessageBodyWidth, kImageHeight)];
        [_remotionImgView setButtonEnable:NO];
        [borderView addSubview:_remotionImgView];
        
        yoffset += kImageHeight + kYGap;
        _abstractLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(xOffset, yoffset, kMessageBodyWidth, 10)];
        [_abstractLabel setTextColor:WXColorWithInteger(0x646464)];
        [_abstractLabel setFont:WXFont(kAbstractFontSize)];
        [_abstractLabel setMutiLine];
        [borderView addSubview:_abstractLabel];
		
		_tipView = [[SysMsgToDetailTipView alloc] initWithFrame:CGRectMake(xOffset, yoffset, kMessageBodyWidth, kSysMsgToDetailTipViewHeight)];
		[borderView addSubview:_tipView];
    }
    return self;
}

- (void)load{
    [super load];
    SysMsgItem *item = self.cellInfo;
    [_titleLabel setText:item.msgTitle];
    [_remotionImgView setCpxViewInfo:item.imageURL];
    [_remotionImgView load];
    
    CGFloat abstractHeight = [[self class] abstractHeight:item];
    CGRect rect = _abstractLabel.frame;
    rect.size.height = abstractHeight;
    [_abstractLabel setFrame:rect];
    [_abstractLabel setText:item.abstract];
	
	CGFloat yOffset = rect.origin.y + rect.size.height + kYGap;
	rect = _tipView.frame;
	rect.origin.y = yOffset;
	[_tipView setFrame:rect];
}

+ (CGFloat)abstractHeight:(SysMsgItem*)item{
    NSString *abstract = item.abstract;
    UIFont *font = WXFont(kAbstractFontSize);
    return [abstract stringHeight:font width:kMessageBodyWidth];
}

+ (CGFloat)titleHeight{
    return [NSString stringHeightOfFont:WXFont(kTitleFontSize)];
}

+ (CGFloat)cellHeightFor:(id)cellInfo{
    return [self abstractHeight:cellInfo] + [self titleHeight] + kImageHeight + kYGap*4 + kSysMsgToDetailTipViewHeight;
}
@end
