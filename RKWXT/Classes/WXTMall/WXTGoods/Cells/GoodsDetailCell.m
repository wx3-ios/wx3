//
//  GoodsDetailCell.m
//  RKWXT
//
//  Created by app on 6/1/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "GoodsDetailCell.h"

@interface GoodsDetailCell(){
    
}

@end

@implementation GoodsDetailCell

-(id)init{
    if (self == [super init]) {
//        UIView * upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 0.25)];
//        upView.backgroundColor = WXColorWithInteger(0xdbdbdb);
//        [self.contentView addSubview:upView];
        
        _ivTitle = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 16, 15)];
        [self.contentView addSubview:_ivTitle];
        
        CGFloat titleX = CGRectGetMaxX(_ivTitle.frame) + 10;
        _lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, 12, 100, 16)];
        _lbTitle.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_lbTitle];
        
        UIButton * detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-30, 15, 10, 10)];
        [detailBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(showDetailInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:detailBtn];
        
//        UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, IPHONE_SCREEN_WIDTH, 0.25)];
//        downView.backgroundColor = WXColorWithInteger(0xdbdbdb);
//        [self.contentView addSubview:downView];
    }
    return self;
}

-(void)showDetailInfo{
    NSLog(@"%s",__func__);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
