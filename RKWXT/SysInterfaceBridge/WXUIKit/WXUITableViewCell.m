//
//  WXUITableViewCell.m
//  CallTesting
//
//  Created by le ting on 4/22/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUITableViewCell.h"

@implementation WXUITableViewCell
@synthesize cellInfo = _cellInfo;
@synthesize baseDelegate = _baseDelegate;

- (void)dealloc{
//    RELEASE_SAFELY(_cellInfo);
    _baseDelegate = nil;
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont:[UIFont systemFontOfSize:kDefaultCellTxtSize]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)load{
    
}
- (void)unload{
    
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
	return 0;
}

#pragma mark accessoryView
- (void)setDefaultAccessoryView:(E_CellDefaultAccessoryViewType)type{
    UIView *accessoryView = nil;
    switch (type) {
        case E_CellDefaultAccessoryViewType_HasNext:
        {
            UIImage *image = [UIImage imageNamed:@"arrow.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image] ;
            accessoryView = imageView;
        }
            break;
        case E_CellDefaultAccessoryViewType_Switch:
        {
            WXUISwitch *wxSwitch = [[WXUISwitch alloc] init] ;
            [wxSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            accessoryView = wxSwitch;
        }
            break;
        case E_CellDefaultAccessoryViewType_Detail:
        {
            UIImage *image = [UIImage imageNamed:@"toDetail.png"];
            WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
            CGSize imageSize = image.size;
            CGFloat min = 44;
            if(imageSize.width < min){
                imageSize.width = min;
            }
            if(imageSize.height < min){
                imageSize.height = min;
            }
            [button setFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
            [button setImage:image forState:UIControlStateNormal];
            accessoryView
            = button;
            [button addTarget:self action:@selector(clickButtonToDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case E_CellDefaultAccessoryViewType_None:{
            accessoryView = nil;
        }
            break;
        default:
            break;
    }
    [self setAccessoryView:accessoryView];
}

- (void)disableTouchDelay{
    for (id obj in self.subviews)
    {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches =NO;
            break;
        }
    }
}

- (void)clickButtonToDetail:(id)sender{
    if(_baseDelegate && [_baseDelegate respondsToSelector:@selector(clickButtonToDetail:)]){
        [_baseDelegate clickButtonToDetail:self];
    }
}

- (void)switchValueChanged:(id)sender{
    if(_baseDelegate && [_baseDelegate respondsToSelector:@selector(switchValueChanged:)]){
        [_baseDelegate switchValueChanged:self];
    }
}

@end
