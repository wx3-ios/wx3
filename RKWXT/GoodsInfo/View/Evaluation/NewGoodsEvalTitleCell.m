//
//  NewGoodsEvalTitleCell.m
//  RKWXT
//
//  Created by app on 16/4/25.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NewGoodsEvalTitleCell.h"

@interface NewGoodsEvalTitleCell ()
{
    UILabel *_title;
    UILabel *_ecalable;
}
@end

@implementation NewGoodsEvalTitleCell

+ (instancetype)goodsEvalTitleCellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"NewGoodsEvalTitleCell";
    NewGoodsEvalTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsEvalTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        
        [self.textLabel setText:@"评价"];
        [self.textLabel setFont:WXFont(14.0)];
        [self.textLabel setTextColor:WXColorWithInteger(0x000000)];
        
        CGFloat titW = 100;
        CGFloat titX = self.width - titW;
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(titX,0 , titW , self.height);
        [_title setBackgroundColor:[UIColor clearColor]];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [_title setTextColor:[UIColor colorWithHexString:@"969696"]];
        [_title setFont:WXFont(14.0)];
        _title.text = @"商品暂无评价";
        [self.contentView addSubview:_title];
        
//        CGFloat xOffset = 100;
        CGFloat moneyWidth = 100;
        CGFloat commonLabelHeight = 18;
        CGFloat xGap = 25;
        _ecalable = [[UILabel alloc] init];
        _ecalable.frame = CGRectMake(self.bounds.size.width-xGap-moneyWidth, (44-commonLabelHeight)/2, moneyWidth, commonLabelHeight);
        [_ecalable setBackgroundColor:[UIColor clearColor]];
        [_ecalable setTextAlignment:NSTextAlignmentRight];
        [_ecalable setTextColor:[UIColor colorWithHexString:@"969696"]];
        [_ecalable setFont:WXFont(14.0)];
        [_ecalable setText:@"查看全部评价"];
        [self.contentView addSubview:_ecalable];
    }
    return self;
}

- (void)isShowGoodsEvaluation:(BOOL)IsShow{
    _title.hidden = !IsShow;
    _title.center = self.center;
    self.textLabel.hidden = IsShow;
    _ecalable.hidden = IsShow;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
