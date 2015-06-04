//
//  WaitReceiveTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitReceiveTitleCell.h"

@interface WaitReceiveTitleCell(){
    UILabel *_fastMail;
    UILabel *_number;
}
@end

@implementation WaitReceiveTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat textWidth = 70;
        CGFloat textHeight = 20;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (WaitReceiveTitleCellHeight-textHeight)/2, textWidth, textHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setFont:WXTFont(12.0)];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [textLabel setText:@"商家已发货"];
        [self.contentView addSubview:textLabel];
        
        CGFloat xGap = 12;
        CGFloat yOffset = 9;
        CGFloat mailWidth = 80;
        CGFloat mailHeight = 16;
        _fastMail = [[UILabel alloc] init];
        _fastMail.frame = CGRectMake(size.width-xGap-mailWidth, yOffset, mailWidth, mailHeight);
        [_fastMail setBackgroundColor:[UIColor clearColor]];
        [_fastMail setTextAlignment:NSTextAlignmentRight];
        [_fastMail setTextColor:WXColorWithInteger(0x000000)];
        [_fastMail setFont:WXTFont(12.0)];
        [self.contentView addSubview:_fastMail];
        
        yOffset += 5;
        CGFloat numWidth = size.width/2;
        CGFloat numHeight = 16;
        _number = [[UILabel alloc] init];
        _number.frame = CGRectMake(size.width-xGap-numWidth, yOffset, numWidth, numHeight);
        [_number setBackgroundColor:[UIColor clearColor]];
        [_number setTextAlignment:NSTextAlignmentRight];
        [_number setTextColor:WXColorWithInteger(0x6d6d6d)];
        [_number setFont:WXTFont(12.0)];
        [self.contentView addSubview:_number];
    }
    return self;
}

-(void)load{
    [_fastMail setText:@"申通快递"];
    [_number setText:@"运单号: 1234567890"];
}

@end
