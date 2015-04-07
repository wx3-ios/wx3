//
//  WXContacterCell.m
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXContacterCell.h"
#import "ContactBaseEntity.h"
#import "UIView+Render.h"

#define kImageViewSize CGSizeMake(30.0,30.0)

@interface WXContacterCell()
{
    WXUIImageView *_imageView;
}
@end

@implementation WXContacterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.textField setFont:WXFont(16.0)];
        [self.textField setTextColor:WXColorWithInteger(0x323232)];
        [self.textField setEnabled:NO];
        [self setTextLabelWidth:50.0];
        _imageView = [[WXUIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewSize.width, kImageViewSize.height)];
        [_imageView toRound];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGFloat height = frame.size.height;
    CGRect rect = _imageView.frame;
    rect.origin = CGPointMake(5, (height -rect.size.height)*0.5);
    [_imageView setFrame:rect];
}

- (void)load{
    [super load];
    ContactBaseEntity *entity = self.cellInfo;
    NSString *name = [entity nameShow];
    UIImage *image = [entity iconShow];
    if(!image){
        image = [UIImage imageNamed:@"defaultContactIcon.png"];
    }
    [self.textField setText:name];
    [_imageView setImage:image];
    
    E_ContactRightView type = [entity rightViewType];
    UIView *accessoryView = nil;
    switch (type) {
        case E_ContactRightView_Add:
        {
            WXUIButton *button = [self accessoryButton];
            [button setTitle:@"添加" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addNewWXFriend) forControlEvents:UIControlEventTouchUpInside];
            accessoryView = button;
        }
            break;
        case E_ContactRightView_Accept:
        {
            WXUIButton *button = [self accessoryButton];
            [button setTitle:@"接受" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
            accessoryView = button;
        }
            break;
        case E_ContactRightView_WaiteForAccpet:
        {
            UILabel *label = [[WXUILabel alloc] init] ;
            [label setFrame:CGRectMake(0, 0, 80, 30)];
            [label setText:@"等待接受"];
            accessoryView = label;
        }
            break;
        case E_ContactRightView_HasNewFriend:
        {
            UILabel *label = [[WXUILabel alloc] init] ;
            [label setFrame:CGRectMake(0, 0, 50, 30)];
            [label setText:[NSString stringWithFormat:@"1"]];
            accessoryView = label;
        }
            break;
        case E_ContactRightView_ShowWXIcon:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxFriend.png"]] ;
            accessoryView = imageView;
        }
            break;
        default:
            break;
    }
    [self setAccessoryView:accessoryView];
}

- (WXUIButton*)accessoryButton{
    WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    return button;
}

- (void)addNewWXFriend{
    
}

- (void)accept{
    
}

@end
