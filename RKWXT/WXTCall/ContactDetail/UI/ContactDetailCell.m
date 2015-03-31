//
//  ContactDetailCell.m
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ContactDetailCell.h"

#define Size self.bounds.size

@interface ContactDetailCell(){
    UILabel *_numberLabel;
}
@end

@implementation ContactDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 20;
        CGFloat numberLabelWidth = 150;
        CGFloat numberLabelHeight = 18;
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.frame = CGRectMake(xOffset, (ContactDetailCellHeight-numberLabelHeight)/2, numberLabelWidth, numberLabelHeight);
        [_numberLabel setBackgroundColor:[UIColor clearColor]];
        [_numberLabel setTextColor:WXColorWithInteger(0x323232)];
        [_numberLabel setFont:WXTFont(15.0)];
        [_numberLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_numberLabel];
        
        CGFloat xGap = 28;
        UIImage *callImg = [UIImage imageNamed:@"ContactInfoCall.png"];
        //        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        callBtn.frame = CGRectMake(Size.width-callImg.size.width-xGap, (ContactDetailCellHeight-callImg.size.height)/2, callImg.size.width, callImg.size.height);
        //        [callBtn setBackgroundColor:[UIColor clearColor]];
        //        [callBtn setImage:callImg forState:UIControlStateNormal];
        ////        [callBtn addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.contentView addSubview:callBtn];
        UIImageView *callImgView = [[UIImageView alloc] init];
        callImgView.frame = CGRectMake(Size.width-callImg.size.width-xGap, (ContactDetailCellHeight-callImg.size.height)/2, callImg.size.width, callImg.size.height);
        [callImgView setImage:callImg];
        [self.contentView addSubview:callImgView];
    }
    return self;
}

-(void)load{
    NSString *phoneNumber = self.cellInfo;
    [_numberLabel setText:phoneNumber];
}

//-(void)callPhone:(id)sender{
//    NSString *phone = self.cellInfo;
//    if(_delegate && [_delegate respondsToSelector:@selector(callContactWithPhone:)]){
//        [_delegate callContactWithPhone:phone];
//    }
//}

@end
