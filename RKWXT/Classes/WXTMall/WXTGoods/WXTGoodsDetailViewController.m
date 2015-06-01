//
//  WXTProductDetailViewController.m
//  RKWXT
//
//  Created by app on 5/28/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTGoodsDetailViewController.h"

@interface WXTGoodsDetailViewController (){
    UITableView * _tableView;
    NSMutableArray * _proPicMArray;
    NSMutableArray * _imageViewsMArray; // 视图
    UIScrollView * _scrollView;
    
    int startContentOffsetX;
    int willEndContentOffsetX;
    int endContentOffsetX;
    int _currentPageIndex;
    NSTimer *_timer;
    NSUInteger _count;
}

@end

@implementation WXTGoodsDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTTitle:@"商品详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

-(void)initUI{
    //右分享
    UIButton * btnShare = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kDefaultNavigationBarButtonSize.width, kDefaultNavigationBarButtonSize.height)];
    
    [self.view addSubview:btnShare];
    
    [self initScrollView];
    [self initTableView];
    // 购物车
    CGFloat cartW = 75;
    CGFloat cartH = 47;
    CGFloat cartY = IPHONE_SCREEN_HEIGHT - cartH;
    UIFont * common = [UIFont systemFontOfSize:14];
    UIButton * btnCart = [[UIButton alloc]initWithFrame:CGRectMake(0, cartY, cartW, cartH)];
    btnCart.backgroundColor = [UIColor purpleColor];
    btnCart.titleLabel.font = common;
    [btnCart setTitle:@"购物车" forState:UIControlStateNormal];
    [btnCart addTarget:self action:@selector(cartDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCart];
    
    UIImageView * cartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 100,100)];
    cartImageView.image = [UIImage imageNamed:@"cart@2x.png"];
    [self.view addSubview:cartImageView];
    
    //立即购买
    CGFloat payW = (IPHONE_SCREEN_WIDTH - cartH)/2;
    UIButton * btnPay = [[UIButton alloc]initWithFrame:CGRectMake(cartW, cartY, payW, cartH)];
    btnPay.backgroundColor = WXColorWithInteger(0xff9c00);
    btnPay.titleLabel.font = common;
    btnPay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnPay setTitle:@"立即购买" forState:UIControlStateNormal];
    [btnPay addTarget:self action:@selector(purchaseAtOnce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPay];
    
    //加入购物车
    UIButton * addCart = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnPay.frame), cartY, payW, cartH)];//X:IPHONE_SCREEN_WIDTH -(IPHONE_SCREEN_WIDTH - cartH/2)
    addCart.backgroundColor = [UIColor redColor];
    addCart.titleLabel.font = common;
    addCart.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [addCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCart addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCart];
    
}

// 头部产品图片
-(void)initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 266)];
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height)];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-10-30, 266-10-30, 30, 30)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Circle"]];
    [_scrollView addSubview:view];
    
}

-(void)initTableView{
    CGFloat tableViewY = IPHONE_SCREEN_HEIGHT-64-226;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewY, IPHONE_SCREEN_WIDTH, tableViewY-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)loadData{
    _count = 5;
    _proPicMArray = [NSMutableArray array];
    _imageViewsMArray = [NSMutableArray array];
    for (int i = 0; i < _count; i ++) {
//        NSString * imageName = [NSString stringWithFormat:@"ab0%d.jpg", i +1];
        NSString * imageName = @"Default@2x.png";
        [_proPicMArray addObject:imageName];
    }
    
    for (int i = 0; i < _count; i ++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i *_scrollView.bounds.size.width,64,_scrollView.bounds.size.width,_scrollView.bounds.size.height)];
        imageView.contentMode =UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [_scrollView addSubview:imageView];
        [_imageViewsMArray addObject:imageView];
    }
}

- (void)dynamicLoadingImageView
{
    for (int i = 0; i < _count; i ++) {
        UIImageView *imageView = [_imageViewsMArray objectAtIndex:i];
        UIImage * image = [UIImage imageNamed:_proPicMArray[i]];
        imageView.image = image;
    }
}

-(void)cartDetail{
    [[CoordinateController sharedCoordinateController] toCartDetail:self animated:YES];
}

// 立即购买
-(void)purchaseAtOnce{
//    [[CoordinateController sharedCoordinateController]toOrderConfirm:self /*delegate:self source:nil goodList:nil goodExtra:nil*/animated:YES];
}

// 加入购物车
-(void)addToCart{
    NSLog(@"%s",__func__);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    endContentOffsetX = scrollView.contentOffset.x;
    if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) {
        //画面从右往左移动，前一页
//        [self pageLeft];
        [self dynamicLoadingImageView];
        //        ((UIImageView*)_imageViewsMArray[_currentPageIndex]).image = [UIImage imageNamed:_advertiseMArray[_currentPageIndex]];
    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {
        //画面从左往右移动，后一页
//        [self pageRight];
        [self dynamicLoadingImageView];
        //        ((UIImageView*)_imageViewsMArray[_currentPageIndex]).image = [UIImage imageNamed:_advertiseMArray[_currentPageIndex]];
    }
}

#pragma mark - 头部产品图片
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 126;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 126)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * proListIdentifier = @"ProductList";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:proListIdentifier];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:proListIdentifier];
    }
//    cell.textLabel.text = @"测试";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
