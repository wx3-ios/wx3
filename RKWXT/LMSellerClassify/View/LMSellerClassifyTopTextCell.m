//
//  LMSellerClassifyTopTextCell.m
//  RKWXT
//
//  Created by SHB on 15/12/14.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerClassifyTopTextCell.h"

@interface LMSellerClassifyTopTextCell(){
    WXUILabel *textLabel;
}
@end

@implementation LMSellerClassifyTopTextCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 25;
        textLabel = [[WXUILabel alloc] init];
        textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        textLabel.frame = CGRectMake(10, 10, labelHeight, labelWidth);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [textLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    NSArray *arr = self.cellInfo;
    [textLabel setText:[NSString stringWithFormat:@"共%d个为你定制标签",arr.count]];
}

@end
