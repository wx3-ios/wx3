//
//  NewAddressAreaCell.m
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "NewAddressAreaCell.h"

@interface NewAddressAreaCell(){
    WXUILabel *textLabel;
}
@end

@implementation NewAddressAreaCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH*3/4;
        CGFloat labelHeight = 25;
        textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (44-labelHeight)/2, labelWidth, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"所在区域"];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:textLabel];
        
        CGFloat btnWidth = 19;
        CGFloat btnHeight = 12;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (44-btnHeight)/2, btnWidth, btnHeight);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setEnabled:NO];
        [btn setImage:[UIImage imageNamed:@"T_ArrowDown.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)load{
    NSString *text = self.cellInfo;
    if(_normalAddress.length > 0){
        [textLabel setText:_normalAddress];
    }
    if(text.length > 0){
        [textLabel setText:text];
    }
}

@end
