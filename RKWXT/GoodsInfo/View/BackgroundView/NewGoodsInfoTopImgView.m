//
//  NewGoodsInfoTopImgView.m
//  RKWXT
//
//  Created by SHB on 15/8/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoTopImgView.h"
#import "NewGoodsInfoTopImgCell.h"
#import "WXRemotionImgBtn.h"

@interface NewGoodsInfoTopImgView()<UITableViewDataSource,UITableViewDelegate,NewGoodsInfotopImgCellDelegate,UIGestureRecognizerDelegate>{
    UITableView *_tableView;
    NSArray *imgArr;
    NSInteger lastScale;
}
@end

@implementation NewGoodsInfoTopImgView

-(id)init{
    self = [super init];
    if(self){
        [self initial];
    }
    return self;
}

-(void)initial{
    _tableView = [[UITableView alloc] init];
    [_tableView setBackgroundColor:[UIColor blackColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setScrollEnabled:NO];
    [self addSubview:_tableView];
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self setUserInteractionEnabled:YES];
    
    lastScale = 1.0;
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaGesture:)];
    [pinchRecognizer setDelegate:self];
//    [self addGestureRecognizer:pinchRecognizer];
}

-(void)scaGesture:(id)sender{
    [self bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    //当手指离开屏幕时，将lastcale设置为1.0
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded){
        lastScale = 1.0;
        return;
    }
    CGFloat third = 0;
//    CGFloat scale = 1.0-(lastScale-[(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    if(lastScale>=1){
        third = 1.01;
    }else{
        third = 0.99;
    }
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, third, third);
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)showTopImgViewWithRootView:(UIView *)rootView withTopImgArr:(NSArray *)topImgArr{
    imgArr = topImgArr;
    self.hidden = NO;
    self.alpha = 0.0;
    [self setFrame:rootView.frame];
    [_tableView setFrame:CGRectMake(0, (rootView.frame.size.height-IPHONE_SCREEN_WIDTH)/2, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_WIDTH+TopImgViewHeight)];
    [rootView addSubview:self];
    
    __block NewGoodsInfoTopImgView *blockSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        [blockSelf show];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE_SCREEN_WIDTH+TopImgViewHeight;
}

-(WXUITableViewCell*)tabelViewForTopImgView{
    static NSString *identifier = @"headImg";
    NewGoodsInfoTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
    for(int i = 0; i< [imgArr count]; i++){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_WIDTH)];
        [imgView setExclusiveTouch:NO];
        [imgView setCpxViewInfo:[imgArr objectAtIndex:i]];
        [merchantImgViewArray addObject:imgView];
    }
    cell = [[NewGoodsInfoTopImgCell alloc] initWithReuseIdentifier:identifier imgNameArray:merchantImgViewArray];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    cell = [self tabelViewForTopImgView];
    return cell;
}

-(void)clickTopImgView{
    [self unShowAnimated:YES];
}

-(void)show{
    [self setAlpha:1.0];
}

-(void)unShow{
    [self setAlpha:0.0];
}

-(void)unShowAnimated:(BOOL)animated{
    if(animated){
        __block NewGoodsInfoTopImgView *blockSelf = self;
        [UIView animateWithDuration:0.4 animations:^{
            [blockSelf unShow];
        }completion:^(BOOL finished) {
            [blockSelf removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

-(void)isClicked{
    [self unShowAnimated:YES];
}

@end
