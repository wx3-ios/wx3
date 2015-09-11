//
//  MyClientMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/9/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientMoneyCell.h"
#import "WXRemotionImgBtn.h"

#define IconImgWidth 52

@interface MyClientMoneyCell(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_desLabel;
}
@end

@implementation MyClientMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = IconImgWidth;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (MyClientMoneyCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 5+(MyClientMoneyCellHeight-imgHeight)/2;
        CGFloat nameWidth = 200;
        CGFloat nameHeight = 20;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(16.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameHeight+4;
        _desLabel = [[WXUILabel alloc] init];
        _desLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_desLabel setBackgroundColor:[UIColor clearColor]];
        [_desLabel setTextAlignment:NSTextAlignmentLeft];
        [_desLabel setTextColor:WXColorWithInteger(0xababab)];
        [_desLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_desLabel];
    }
    return self;
}

-(void)load{
    CGFloat money = [self.cellInfo floatValue];
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfoHeadImg.jpg"];
    [_imgView setImage:iconImg];
    if(![_userIcon isEqualToString:AllImgPrefixUrlString] && _userIcon){
        [_imgView setCpxViewInfo:_userIcon];
        [_imgView load];
    }
    [_imgView setBorderRadian:IconImgWidth/2 width:1.0 color:[UIColor clearColor]];
    [_nameLabel setText:[NSString stringWithFormat:@"您已获得%.2f元提成",money]];
    
    NSString *deston = _userName;
    if(deston.length == 0){
        deston = _clientID;
    }
    [_desLabel setText:[NSString stringWithFormat:@"来自%@的分成",deston]];
}

@end
