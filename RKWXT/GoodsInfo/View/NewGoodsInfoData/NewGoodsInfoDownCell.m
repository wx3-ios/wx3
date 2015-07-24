//
//  NewGoodsInfoDownCell.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoDownCell.h"

#define OneCellHeight (30)

@interface NewGoodsInfoDownCell(){
    WXUILabel *_commonLabel;
    WXUILabel *_infoLabel;
}
@end

@implementation NewGoodsInfoDownCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        _commonLabel = [[WXUILabel alloc] init];
        _commonLabel.frame = CGRectMake(15, 0, 100, OneCellHeight);
        [_commonLabel setBackgroundColor:[UIColor clearColor]];
        [_commonLabel setTextAlignment:NSTextAlignmentLeft];
        [_commonLabel setTextColor:[UIColor blackColor]];
        [_commonLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.contentView addSubview:_commonLabel];
        
        _infoLabel = [[WXUILabel alloc] init];
        _infoLabel.frame = CGRectMake(150, 0, IPHONE_SCREEN_WIDTH-150-15, OneCellHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentRight];
        [_infoLabel setTextColor:[UIColor blackColor]];
        [_infoLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

-(void)load{
    [_commonLabel setText:_name];
    [_infoLabel setText:_info];
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return OneCellHeight;
}

@end
