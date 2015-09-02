//
//  NewGoodsInfoBigImgView.m
//  RKWXT
//
//  Created by SHB on 15/9/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoBigImgView.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"

@interface NewGoodsInfoBigImgView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation NewGoodsInfoBigImgView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"图片浏览"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_imgArr count]/3+([_imgArr count]%3>0?1:0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"photo";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
    NSMutableArray *temp = [NSMutableArray array];
    [_imgArr enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
        item.thumbnail_pic = src;
        [temp addObject:item];
    }];
    
    photoGroup.photoItemArray = [temp copy];
    [cell.contentView addSubview:photoGroup];
    return cell;
}

@end
