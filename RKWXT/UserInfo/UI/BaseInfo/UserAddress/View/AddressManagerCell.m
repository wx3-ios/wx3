//
//  AddressManagerCell.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AddressManagerCell.h"
#import "AddressEntity.h"

@interface AddressManagerCell(){
    WXUIButton *_selBtn;
    BOOL bSelected;
}
@end

@implementation AddressManagerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        UIImage *img = [UIImage imageNamed:@"AddressCircle.png"];
        _selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selBtn.frame = CGRectMake(xOffset, (AddressManagerCellHeight-img.size.height)/2, img.size.width, img.size.height);
        [_selBtn setBackgroundColor:[UIColor clearColor]];
        [_selBtn setImage:img forState:UIControlStateNormal];
        [_selBtn addTarget:self action:@selector(setAddressNormal:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selBtn];
        
        xOffset += img.size.width+10;
        CGFloat norAddWidth = 80;
        CGFloat norAddheight = 15;
        UILabel *norAddLabel = [[UILabel alloc] init];
        norAddLabel.frame = CGRectMake(xOffset, (AddressManagerCellHeight-norAddheight)/2, norAddWidth, norAddheight);
        [norAddLabel setBackgroundColor:[UIColor clearColor]];
        [norAddLabel setTextAlignment:NSTextAlignmentLeft];
        [norAddLabel setText:@"默认地址"];
        [norAddLabel setTextColor:WXColorWithInteger(0x8a8a8a)];
        [norAddLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:norAddLabel];
        
        xOffset = IPHONE_SCREEN_WIDTH-125;
        UIImage *editImg = [UIImage imageNamed:@"AddressEdit.png"];
        WXUIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(xOffset, (AddressManagerCellHeight-editImg.size.height)/2, editImg.size.width, editImg.size.height);
        [editBtn setBackgroundColor:[UIColor clearColor]];
        [editBtn setImage:editImg forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
        
        CGFloat xGap = xOffset+editImg.size.width+6;
        CGFloat labelWidth = norAddWidth/2;
        UILabel *editLabel = [[UILabel alloc] init];
        editLabel.frame = CGRectMake(xGap, (AddressManagerCellHeight-norAddheight)/2, labelWidth, norAddheight);
        [editLabel setBackgroundColor:[UIColor clearColor]];
        [editLabel setTextAlignment:NSTextAlignmentLeft];
        [editLabel setText:@"编辑"];
        [editLabel setTextColor:WXColorWithInteger(0x8a8a8a)];
        [editLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:editLabel];
        
        
        UIImage *delImg = [UIImage imageNamed:@"AddressDel.png"];
        xGap += labelWidth+10;
        WXUIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(xGap, (AddressManagerCellHeight-delImg.size.height)/2, delImg.size.width, delImg.size.height);
        [delBtn setBackgroundColor:[UIColor clearColor]];
        [delBtn setImage:editImg forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delAdd) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
        
        xGap += delImg.size.width+11;
        UILabel *delLabel = [[UILabel alloc] init];
        delLabel.frame = CGRectMake(xGap, (AddressManagerCellHeight-norAddheight)/2, labelWidth, norAddheight);
        [delLabel setBackgroundColor:[UIColor clearColor]];
        [delLabel setTextAlignment:NSTextAlignmentLeft];
        [delLabel setText:@"删除"];
        [delLabel setTextColor:WXColorWithInteger(0x8a8a8a)];
        [delLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:delLabel];
    }
    return self;
}

-(void)load{
    AddressEntity *ent = self.cellInfo;
    bSelected = ![ent.bSel integerValue];
    [self setAddressNormal:YES];
}

-(void)setAddressNormal:(BOOL)load{
    AddressEntity *ent = self.cellInfo;
    if(!bSelected){
        bSelected = YES;
        ent.bSel = @"1";  //1代表勾选
        [_selBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        bSelected = NO;
        ent.bSel = @"0";
        [_selBtn setImage:[UIImage imageNamed:@"AddressCircle.png"] forState:UIControlStateNormal];
    }
    if(!load){
        if(_delegate && [_delegate respondsToSelector:@selector(setAddressNormal:)]){
            [_delegate setAddressNormal:ent];
        }
    }
}

-(void)editAddress{
    AddressEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(editAddressInfo:)]){
        [_delegate editAddressInfo:entity];
    }
}

-(void)delAdd{
    AddressEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(delAddress:)]){
        [_delegate delAddress:entity];
    }
}

@end
