//
//  NewGoodsInfoDownCell.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoDownCell.h"

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

-(void)setTextLabelWithKey:(NSString *)key{
    NSDictionary *dic = self.cellInfo;
    NSString *name = [[self class] chineseWithKey:key];
    name = [name stringByAppendingString:[dic objectForKey:key]];
    [_commonLabel setText:name];
}

-(void)load{
    
}

+(NSString*)chineseWithKey:(NSString*)key{
    if(!key){
        return nil;
    }
    NSString *chineseStr = nil;
    if([key isEqualToString:@"goods_alloy"]){
        chineseStr = @"成色: ";
    }
    if([key isEqualToString:@"goods_style"]){
        chineseStr = @"款式: ";
    }
    if([key isEqualToString:@"goods_material"]){
        chineseStr = @"材质: ";
    }
    if([key isEqualToString:@"goods_package"]){
        chineseStr = @"包装: ";
    }
    if([key isEqualToString:@"goods_guarantee"]){
        chineseStr = @"保证书: ";
    }
    if([key isEqualToString:@"producing_area"]){
        chineseStr = @"产地: ";
    }
    if([key isEqualToString:@"suit_crowd"]){
        chineseStr = @"适合人群: ";
    }
    if([key isEqualToString:@"goods_size"]){
        chineseStr = @"尺寸: ";
    }
    if([key isEqualToString:@"goods_weight"]){
        chineseStr = @"质量: ";
    }
    
    return chineseStr;
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return OneCellHeight;
}

@end
