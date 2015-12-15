//
//  LMSellerClassifyTopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/14.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerClassifyTopCell.h"
#import "ShopUnionClassifyEntity.h"

#define Size self.bounds.size

@interface LMSellerClassifyTopCell(){
    WXUILabel *nameLabel;
}
@end

@implementation LMSellerClassifyTopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat labelHeight = 25;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        nameLabel.frame = CGRectMake(0, (ScrollViewHeight-labelHeight)/2, ScrollViewHeight, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:WXFont(15.0)];
        [nameLabel setTextColor:WXColorWithInteger(0x999999)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    ShopUnionClassifyEntity *entity = self.cellInfo;
    [nameLabel setText:entity.industryName];
    
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    if([[userDefault textValueForKey:@"industryName"] isEqualToString:entity.industryName]){
        [nameLabel setTextColor:WXColorWithInteger(0xdd2726)];
    }else{
        [nameLabel setTextColor:WXColorWithInteger(0x999999)];
    }
    
    CGRect rect = nameLabel.frame;
    rect.size.height = [[self class] widthForString:entity.industryName fontSize:16.0 andHeight:ScrollViewHeight];
    [nameLabel setFrame:rect];
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    ShopUnionClassifyEntity *entity = cellInfo;
    CGFloat nameWidth = [self widthForString:entity.industryName fontSize:16.0 andHeight:ScrollViewHeight];
    return nameWidth;
}

+(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

@end
