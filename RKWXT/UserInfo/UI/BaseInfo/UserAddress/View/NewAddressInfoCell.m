//
//  NewAddressInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "NewAddressInfoCell.h"

@interface NewAddressInfoCell()<WXUITextViewDelegate>{
    WXUITextView *textView;
}
@end

@implementation NewAddressInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat height = 50;
        textView = [[WXUITextView alloc] init];
        textView.frame = CGRectMake(xOffset, (NewAddressInfoCellHeight-height)/2, IPHONE_SCREEN_WIDTH-2*xOffset, height);
        [textView setPlaceholder:@"详细地址"];
        [textView setFont:WXFont(14.0)];
        [textView setWxDelegate:self];
        [self.contentView addSubview:textView];
    }
    return self;
}

-(void)load{
    NSString *address = self.cellInfo;
    if(address){
        [textView setText:address];
    }
}

-(void)wxTextViewDidChange:(WXUITextView *)textView{
    if(_delegate && [_delegate respondsToSelector:@selector(textViewValueDidChanged:)]){
        [_delegate textViewValueDidChanged:textView.text];
    }
}

@end
