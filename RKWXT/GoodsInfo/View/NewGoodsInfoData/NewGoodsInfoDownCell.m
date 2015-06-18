//
//  NewGoodsInfoDownCell.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoDownCell.h"
#import "GoodsInfoEntity.h"

#define OneCellHeight (18)

@interface NewGoodsInfoDownCell(){
    WXUILabel *_commonLabel;
}
@end

@implementation NewGoodsInfoDownCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setBackgroundColor:WXColorWithInteger(0xEBEBEB)];
        _commonLabel = [[WXUILabel alloc] init];
        _commonLabel.frame = CGRectMake(15, 0, 200, OneCellHeight);
        [_commonLabel setBackgroundColor:[UIColor clearColor]];
        [_commonLabel setTextAlignment:NSTextAlignmentLeft];
        [_commonLabel setTextColor:[UIColor blackColor]];
        [_commonLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.contentView addSubview:_commonLabel];
    }
    return self;
}

-(void)load{
    NSString *desStr = self.cellInfo;
    [_commonLabel setText:desStr];
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return OneCellHeight;
}

@end
