//
//  LMOrderInfoUserAddressCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoUserAddressCell.h"
#import "LMOrderListEntity.h"

@interface LMOrderInfoUserAddressCell(){
    UILabel *_nameLabel;
    UILabel *_address;
}
@end

@implementation LMOrderInfoUserAddressCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 6;
        CGFloat yOffset = 4;
        CGFloat imgWidth = 10;
        CGFloat imgHeight = imgWidth+5;
        UIImage *img = [UIImage imageNamed:@"OrderInfoUserAdd.png"];
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, yOffset, imgWidth, imgHeight);
        [imgView setImage:img];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat textWidth = 70;
        CGFloat textHeight = 15;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"收货地址"];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setFont:WXFont(14.0)];
        [textLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:textLabel];
        
        yOffset += textHeight+4;
        CGFloat nameWidth = 200;
        CGFloat nameHeight = 12;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXFont(12.0)];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameHeight+4;
        CGFloat addressWidth = IPHONE_SCREEN_WIDTH-xOffset-4;
        CGFloat addressHeight = 12;
        _address = [[UILabel alloc] init];
        _address.frame = CGRectMake(xOffset, yOffset, addressWidth, addressHeight);
        [_address setBackgroundColor:[UIColor clearColor]];
        [_address setTextAlignment:NSTextAlignmentLeft];
        [_address setTextColor:[UIColor grayColor]];
        [_address setFont:WXFont(12.0)];
        [_address setNumberOfLines:0];
        [self.contentView addSubview:_address];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [_nameLabel setText:[NSString stringWithFormat:@"%@  %@",entity.userName,entity.userPhone]];
    [_address setText:entity.userAddress];
    
    CGRect rect = _address.frame;
    rect.size.height = [entity.userAddress stringHeight:WXFont(12.0) width:IPHONE_SCREEN_WIDTH-10];
    [_address setFrame:rect];
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    LMOrderListEntity *entity = cellInfo;
    CGFloat height = 55;
    NSString *add = entity.userAddress;
    CGFloat addHeight = [add stringHeight:WXFont(12.0) width:IPHONE_SCREEN_WIDTH-30];
    height += addHeight;
    return height;
}

@end
