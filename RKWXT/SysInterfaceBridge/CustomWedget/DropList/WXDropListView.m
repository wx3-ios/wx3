//
//  WXDropListView.m
//  DropList
//
//  Created by le ting on 5/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXDropListView.h"
#import "WXMaskView.h"

typedef enum {
    E_DropListStatus_Close = 0,
    E_DropListStatus_Open,
}E_DropListStatus;

#define kAnimatedDur 0.2
@interface WXDropListView()<UITableViewDataSource,UITableViewDelegate,WXMaskViewDelegate>{
    //背景
    WXMaskView *_bgView;
    
    //dropView的superView
    WXUIView *_clipeView;
    WXUITableView *_tableView;
    NSArray *_dataList;
    
    E_DropListStatus _dropListStatus;
    CGRect _originListRect;
}
@property (nonatomic,retain)WXUIButton *menuBtn;
@end

@implementation WXDropListView
@synthesize menuBtn = _menuBtn;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize dataList = _dataList;
@synthesize dropDirection = _dropDirection;
@synthesize delegate = _delegate;

- (void)dealloc{
//    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame menuButton:(WXUIButton*)memuButton dropListFrame:(CGRect)dropListFrame{
    if(self = [super initWithFrame:frame]){
        _bgView = [[WXMaskView alloc] initWithFrame:self.bounds];
        [_bgView setDelegate:self];
        [_bgView setHidden:NO];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [_bgView setAlpha:0.5];
        [self addSubview:_bgView];
        //保存droplist的原始尺寸
        _originListRect = dropListFrame;
        
        _clipeView = [[WXUIView alloc] initWithFrame:dropListFrame];
        [_clipeView setClipsToBounds:YES];
        [self addSubview:_clipeView];
        _tableView = [[WXUITableView alloc] initWithFrame:_clipeView.bounds style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 5;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_clipeView addSubview:_tableView];
        
        self.menuBtn = memuButton;
        [_menuBtn addTarget:self action:@selector(menuButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _dropListStatus = E_DropListStatus_Open;
    }
    return self;
}

- (void)menuButtonClick{
    if(_dropListStatus == E_DropListStatus_Open){
        [self unshow:YES];
    }else{
        [self showAnimated:YES];
    }
}

- (void)showAnimated:(BOOL)animated{
    [self setHidden:NO];
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeView setFrame:_originListRect];
        } completion:^(BOOL finished) {
        }];
    }else{
        [_clipeView setFrame:_originListRect];
    }
    _dropListStatus = E_DropListStatus_Open;
}

- (void)unshow:(BOOL)animated{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    if(_dropDirection == E_DropDirection_Right){
        rect.origin = _originListRect.origin;
    }else{
        rect.origin = CGPointMake(_originListRect.origin.x + _originListRect.size.width, _originListRect.origin.y);
    }
    if(animated){
        [UIView animateWithDuration:kAnimatedDur animations:^{
            [_clipeView setFrame:rect];
        } completion:^(BOOL finished) {
            [self setHidden:YES];
        }];
    }else{
        [_clipeView setFrame:rect];
        [self setHidden:YES];
    }
    _dropListStatus = E_DropListStatus_Close;
}

- (void)maskViewIsClicked{
    [self unshow:YES];
}

#pragma mark UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        [cell.textLabel setFont:[self currentFont]];
        [cell.textLabel setTextColor:[self currentTextColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    WXDropListItem *item = [_dataList objectAtIndex:indexPath.row];
    UIImage *icon = [UIImage imageNamed:item.icon];
    if(icon){
        [cell.imageView setImage:icon];
    }
    [cell.textLabel setText:item.title];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self currentRowHeight];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self unshow:YES];
    if(_delegate && [_delegate respondsToSelector:@selector(menuClickAtIndex:)]){
        [_delegate menuClickAtIndex:indexPath.row];
    }
}

#pragma mark arr
- (UIFont*)currentFont{
    UIFont *font = [UIFont systemFontOfSize:10.0];
    if(_font){
        font = _font;
    }
    return font;
}

- (UIColor*)currentTextColor{
    UIColor *color = [UIColor blackColor];
    if(_textColor){
        color = _textColor;
    }
    return color;
}

- (CGFloat)currentRowHeight{
    NSInteger rowCount = [_dataList count];
    CGFloat height = 0.0;
    if(rowCount > 0){
        height = _originListRect.size.height/rowCount;
    }
    return height;
}

@end
