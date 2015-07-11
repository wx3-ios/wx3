//
//  ShopTwoDimensionCell.m
//  Woxin2.0
//
//  Created by qq on 14-10-14.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "ShopTwoDimensionCell.h"

@interface ShopTwoDimensionCell()
{
	UIImageView *_thumbView;
}
@end

@implementation ShopTwoDimensionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.textLabel setText:@"商家二维码"];
        [self.textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.textLabel setTextAlignment:NSTextAlignmentLeft];
        [self.textLabel setTextColor:WXColorWithInteger(0x646464)];
        
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_thumbView setImage:[UIImage imageNamed:@"TwoDimension.png"]];
		[self addSubview:_thumbView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
	[super setFrame:frame];
	CGSize size = frame.size;
	CGSize thumbViewSize = _thumbView.bounds.size;
	CGRect rect = CGRectMake(size.width-thumbViewSize.width-10, (size.height-thumbViewSize.height)*0.5, thumbViewSize.width, thumbViewSize.height);
	[_thumbView setFrame:rect];
}

- (UIView*)thumbView{
    return _thumbView;
}

@end
