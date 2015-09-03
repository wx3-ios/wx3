//
//  NewGoodsInfoZoomImgItem.m
//  RKWXT
//
//  Created by SHB on 15/9/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoZoomImgItem.h"

@implementation NewGoodsInfoZoomImgItem

- (void)dealloc {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib{
    // Initialization code
}

- (void)_initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    imageView = [[GoodsInfoImageZoomView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageView];
}

- (void)setImgName:(NSString *)imgName {
    [imageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    [imageView uddateImageWithUrl:imgName];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
