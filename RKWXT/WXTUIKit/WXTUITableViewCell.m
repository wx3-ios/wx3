//
//  WXTUITableViewCell.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

@implementation WXTUITableViewCell
@synthesize cellInfo = _cellInfo;
@synthesize baseDelegate = _baseDelegate;

-(void)dealloc{
    _baseDelegate = nil;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.textLabel setFont:[UIFont systemFontOfSize:12.0]];
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

-(void)load{

}

-(void)unload{
    
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 0;
}

#pragma mark accessoryView
-(void)setDefaultAccessoryView:(WXT_CellDefaultAccessoryType)type{
    UIView *accessoryView = nil;
    switch (type) {
        case WXT_CellDefaultAccessoryType_HasNext:
        {
            UIImage *image = [UIImage imageNamed:@"Arrow.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            accessoryView = imageView;
        }
            break;
        case WXT_CellDefaultAccessoryType_Switch:
        {
            UISwitch *wxtSwitch = [[UISwitch alloc] init];
            [wxtSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            accessoryView = wxtSwitch;
        }
            break;
        case WXT_CellDefaultAccessoryType_Detail:
        {
            UIImage *image = [UIImage imageNamed:@"toDetail.png"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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
            accessoryView = button;
            [button addTarget:self action:@selector(clickButtonToDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            case WXT_CellDefaultAccessoryType_None:
        {
            accessoryView = nil;
        }
            break;
        default:
            break;
    }
    [self setAccessoryView:accessoryView];
}

-(void)clickButtonToDetail:(id)sender{
    if(_baseDelegate && [_baseDelegate respondsToSelector:@selector(clickButtonToDetail:)]){
        [_baseDelegate clickButtonToDetail:self];
    }
}

-(void)switchValueChanged:(id)sender{
    if(_baseDelegate && [_baseDelegate respondsToSelector:@selector(switchValueChanged:)]){
        [_baseDelegate switchValueChanged:self];
    }
}


@end
