//
//  PictureBrowseView.m
//  Test
//
//  Created by Elty on 10/14/14.
//  Copyright (c) 2014 Elty. All rights reserved.
//

#import "PictureBrowseView.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

@interface PictureBrowseView()
{
	UIView *_maskShell;
	UIImageView *_imageView;
	
	CGRect _imageViewDestRect;
	CGRect _imageViewSourceRect;
	
	CGFloat _duration;
	CGFloat _maskAlpha;
}
@property (nonatomic,retain)UIView *thumbView;
@end

@implementation PictureBrowseView

- (void)dealloc{
//	[super dealloc];
}

- (id)init{
	if (self = [super init]){
		[self initial];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]){
		[self initial];
	}
	return self;
}

- (void)initial{
	_maskShell = [[UIView alloc] init];
	[_maskShell setBackgroundColor:[UIColor blackColor]];
	[_maskShell setAlpha:kMaskShellDefaultAlpha];
	[self addSubview:_maskShell];
	_imageView = [[UIImageView alloc] init];
	[self addSubview:_imageView];
	[self setAlpha:0.0];
	
	_duration = kAnimateDefaultDuration;
	_maskAlpha = kMaskShellDefaultAlpha;
	
	[self setUserInteractionEnabled:YES];
}

- (void)showthumbView:(UIView*)thumbView toDestView:(UIView*)destView withImage:(UIImage*)image animated:(BOOL)animated{
	self.hidden = NO;
	self.alpha = 0.0;
	
	[self setThumbView:thumbView];
	[_maskShell setFrame:destView.bounds];
	[self setFrame:destView.bounds];
	UIView *superView = thumbView.superview;
	NSAssert(superView, @"thumb view has not add to super view");
	_imageViewSourceRect = [destView convertRect:thumbView.frame fromView:thumbView.superview];
	[_imageView setImage:image];
	[_imageView setFrame:_imageViewSourceRect];
	
	CGSize destViewSize = destView.bounds.size;
	CGSize destThumbSize = image.size;
	_imageViewDestRect = CGRectMake((destViewSize.width-destThumbSize.width)*0.5, (destViewSize.height-destThumbSize.height)*0.5, destThumbSize.width, destThumbSize.height);
	
	[destView addSubview:self];
	if (animated){
		__block PictureBrowseView *blockSelf = self;
		[UIView animateWithDuration:_duration animations:^{
			[blockSelf show];
		}];
	}else{
		[self show];
	}
}

- (void)show{
	[_imageView setFrame:_imageViewDestRect];
	[self.thumbView setAlpha:0.0];
	[self setAlpha:1.0];
}

- (void)unshow{
	[_imageView setFrame:_imageViewSourceRect];
	[self.thumbView setAlpha:1.0];
	[self setAlpha:0.0];
}

- (void)unshowAnimated:(BOOL)animated{
	if (animated){
		__block PictureBrowseView *blockSelf = self;
		[UIView animateWithDuration:_duration animations:^{
			[blockSelf unshow];
		} completion:^(BOOL finished) {
			[blockSelf removeFromSuperview];
		}];
		
	}else{
		[self removeFromSuperview];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[self isClicked];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self isClicked];
}

- (void)isClicked{
	[self unshowAnimated:YES];
}
@end
