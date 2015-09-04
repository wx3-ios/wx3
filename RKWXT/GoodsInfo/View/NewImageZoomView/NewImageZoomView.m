//
//  NewImageZoomView.m
//  RKWXT
//
//  Created by SHB on 15/9/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewImageZoomView.h"
#import "NewGoodsInfoZoomImgItem.h"

@interface NewImageZoomView ()<UITableViewDelegate,UITableViewDataSource>{
    CGSize v_size;
    UITableView *m_TableView;
    UILabel *progressLabel;
}
@end

@implementation NewImageZoomView

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size{
    self = [super initWithFrame:frame];
    if (self) {
        v_size = size;
        [self _initView];
    }
    return self;
}

- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index{
    self.imgs = imageArr;
    [m_TableView reloadData];
    if (index > 0 && index < self.imgs.count) {
        NSInteger row = MAX(index, 0);
        [m_TableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)index + 1, (long)self.imgs.count];
}

- (void)_initView{
    m_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)
                                               style:UITableViewStylePlain];
    m_TableView.delegate = self;
    m_TableView.dataSource = self;
    m_TableView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    m_TableView.showsVerticalScrollIndicator = NO;
    m_TableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    m_TableView.pagingEnabled = YES;
    m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_TableView.backgroundView = nil;
    m_TableView.backgroundColor = [UIColor blackColor];
    [self addSubview:m_TableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(TapsAction:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 20)];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.font = [UIFont systemFontOfSize:15];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:progressLabel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idty = @"imgshowCell";
    NewGoodsInfoZoomImgItem *cell = [tableView dequeueReusableCellWithIdentifier:idty];
    if (nil == cell) {
        cell = [[NewGoodsInfoZoomImgItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idty];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    cell.size = self.bounds.size;
    NSString *imgStr = [self.imgs objectAtIndex:indexPath.row];
    cell.imgName = imgStr;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.width;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
    progressLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)index.row + 1, (long)self.imgs.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *index =  [m_TableView indexPathForRowAtPoint:scrollView.contentOffset];
    progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)index.row + 1, (long)self.imgs.count];
    NSLog(@"index.row : %ld", (long)index.row);
}

- (void)TapsAction:(UITapGestureRecognizer *)tap{
    NSInteger tapCount = tap.numberOfTapsRequired;
    if (1 == tapCount) {
        [self isClicked];
    }
}

-(void)show{
    [self setAlpha:1.0];
}

-(void)unShow{
    [self setAlpha:0.0];
}

-(void)unShowAnimated:(BOOL)animated{
    if(animated){
        __block NewImageZoomView *blockSelf = self;
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
