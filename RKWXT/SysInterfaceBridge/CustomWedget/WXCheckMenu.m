//
//  WXCheckMenu.m
//  CallTesting
//
//  Created by le ting on 5/17/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXCheckMenu.h"

@interface WXCheckMenu()
{
    NSMutableArray *_buttonArray;
}
@end

@implementation WXCheckMenu
@synthesize delegate = _delegate;

- (void)dealloc{
    RELEASE_SAFELY(_buttonArray);
    [super dealloc];
}

+ (id)checkMenuWithTitleArray:(NSArray*)titles normalImageArray:(NSArray*)normalImgArray selectedImageArray:(NSArray*)selectedImgArray{
    return [[[self alloc] initWithTitleArray:titles normalImageArray:normalImgArray selectedImageArray:selectedImgArray] autorelease];
}

- (id)initWithTitleArray:(NSArray*)titles normalImageArray:(NSArray*)normalImgArray selectedImageArray:(NSArray*)selectedImgArray{
    if(self = [super init]){
        NSInteger titleCount = [titles count];
        NSInteger normalImgCount = [normalImgArray count];
        NSInteger selImgCount = [selectedImgArray count];
        
        NSAssert(normalImgCount == selImgCount, @"check menu 图片不配对");
        if(titleCount > 0){
            NSAssert(titleCount == normalImgCount, @"title不配对");
        }
        NSInteger count = [normalImgArray count];
        _buttonArray = [[NSMutableArray alloc] init];
        CGFloat xOffset = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        for(int i = 0; i < count; i++){
            NSString *title = [titles objectAtIndex:i];
            UIImage *normalImg = [normalImgArray objectAtIndex:i];
            UIImage *selImg = [selectedImgArray objectAtIndex:i];
            CGSize btnSize = normalImg.size;
            if(btnSize.height > height){
                height = btnSize.height;
            }
            WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:normalImg forState:UIControlStateNormal];
            [button setBackgroundImage:selImg forState:UIControlStateHighlighted];
            [button setBackgroundImage:selImg forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if(title){
                [button setTitle:title forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [button setFrame:CGRectMake(xOffset, 0, btnSize.width, btnSize.height)];
            xOffset += btnSize.width;
            width += btnSize.width;
            [_buttonArray addObject:button];
            [self addSubview:button];
        }
        [self setFrame:CGRectMake(0, 0, width, height)];
    }
    return self;
}

- (NSInteger)selectedIndex{
    NSInteger index = NSNotFound;
    for(WXUIButton *button in _buttonArray){
        if(button.selected == YES){
            index = [_buttonArray indexOfObject:button];
            break;
        }
    }
    return index;
}

- (void)setSelectedAtIndex:(NSInteger)index{
    NSInteger btnCount = [_buttonArray count];
    if(btnCount <= index || index < 0){
        KFLog_Normal(YES, @"无效的index");
        return;
    }
    
    NSInteger lastIndex = [self selectedIndex];
    //如果是同一个index
    if(index == lastIndex){
        return;
    }
    
    WXUIButton *lastBtn = nil;
    if(lastIndex != NSNotFound){
        lastBtn = [_buttonArray objectAtIndex:lastIndex];
    }
    [lastBtn setSelected:NO];
    WXUIButton *thisBtn = [_buttonArray objectAtIndex:index];
    [thisBtn setSelected:YES];
}

- (void)buttonClick:(id)sender{
    NSInteger index = [_buttonArray indexOfObject:sender];
    if(index != NSNotFound){
        [self setSelectedAtIndex:index];
        if(_delegate && [_delegate respondsToSelector:@selector(menuButtonClickAtIndex:)]){
            [_delegate menuButtonClickAtIndex:index];
        }
    }
}

@end
