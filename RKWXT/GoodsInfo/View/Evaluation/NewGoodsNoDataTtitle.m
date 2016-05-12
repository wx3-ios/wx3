//
//  NewGoodsNoDataTtitle.m
//  RKWXT
//
//  Created by app on 16/5/12.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NewGoodsNoDataTtitle.h"

@interface NewGoodsNoDataTtitle ()
{
    UILabel *_title;
}
@end

@implementation NewGoodsNoDataTtitle

+ (instancetype)NewGoodsNoDataTtitleWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"TitleCell";
    NewGoodsNoDataTtitle *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsNoDataTtitle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        
        CGFloat titW = 100;
        CGFloat titX = (self.width - titW) / 2;
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(titX,0 , titW , self.height);
        [_title setBackgroundColor:[UIColor clearColor]];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [_title setTextColor:[UIColor colorWithHexString:@"969696"]];
        [_title setFont:WXFont(14.0)];
        _title.text = @"商品暂无评价";
        [self.contentView addSubview:_title];
        
   
    }
    return self;
}

@end
