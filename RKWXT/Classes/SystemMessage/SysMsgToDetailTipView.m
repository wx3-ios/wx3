//
//  SysMsgToDetailTipView.m
//  Woxin2.0
//
//  Created by Elty on 10/27/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgToDetailTipView.h"
#import "SysMsgUIDef.h"

#define kSysMsgToDetailTipViewLineHeight (0.3)
@implementation SysMsgToDetailTipView


- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]){
		WXUITextField *textFiled = [[WXUITextField alloc] initWithFrame:CGRectMake(8, kSysMsgToDetailTipViewLineHeight, 200, frame.size.height-kSysMsgToDetailTipViewLineHeight)];
		[textFiled setEnabled:NO];
		[textFiled setTextAlignment:NSTextAlignmentLeft];
		[textFiled setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[textFiled setFont:WXFont(11.0)];
		[textFiled setTextColor:WXColorWithInteger(0x252525)];
		[textFiled setText:@"查看全文"];
		[self addSubview:textFiled];
		
		UIImage *img = [UIImage imageNamed:@"T_ArrowRight.png"];
		WXUIImageView *imgView = [[WXUIImageView alloc] initWithImage:img];
		CGSize imgSize = img.size;
		CGRect imgRect = CGRectMake(frame.size.width - imgSize.width - 5, 0.5*(frame.size.height-imgSize.height), imgSize.width, imgSize.height);
		[imgView setFrame:imgRect];
		[self addSubview:imgView];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, kSysMsgToDetailTipViewLineHeight);
	UIColor *lineColor = [UIColor colorWithRGB:0xd2d2d2 alpha:0.8];
	CGFloat r = 0,g = 0,b = 0,alpha = 0;
	[lineColor getRed:&r green:&g blue:&b alpha:&alpha];
	CGContextSetRGBStrokeColor(context, r, g, b, alpha);
	CGFloat y = kSysMsgToDetailTipViewLineHeight;
	CGContextMoveToPoint(context, 0, y);
	CGContextAddLineToPoint(context, rect.size.width, y);
	CGContextStrokePath(context);
}

@end
