//
//  UserRefereeCell.m
//  RKWXT
//
//  Created by SHB on 15/9/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserRefereeCell.h"
#import "WXRemotionImgBtn.h"

@interface UserRefereeCell(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_companyLabel;
    WXUILabel *_moneyLabel;
    WXUILabel *_registerTimeLabel;
}
@end

@implementation UserRefereeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat imgWidth = 52;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        yOffset += 8;
        CGFloat nameWidth = 200;
        CGFloat nameHight = 20;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameHight+8;
        _companyLabel = [[WXUILabel alloc] init];
        _companyLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHight);
        [_companyLabel setBackgroundColor:[UIColor clearColor]];
        [_companyLabel setTextColor:WXColorWithInteger(0x000000)];
        [_companyLabel setTextAlignment:NSTextAlignmentLeft];
        [_companyLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_companyLabel];
        
        CGFloat xGap = 15;
        yOffset += nameHight+15;
        CGFloat textWidth = 70;
        CGFloat textHeight = 20;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xGap, yOffset, textWidth, textHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setFont:WXFont(13.0)];
        [textLabel setText:@"我的贡献:"];
        [textLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:textLabel];
        
        xGap += textWidth;
        _moneyLabel = [[WXUILabel alloc] init];
        _moneyLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_moneyLabel setTextAlignment:NSTextAlignmentLeft];
        [_moneyLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_moneyLabel];
        
        yOffset += textHeight+10;
        _registerTimeLabel = [[WXUILabel alloc] init];
        _registerTimeLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_registerTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_registerTimeLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_registerTimeLabel setTextAlignment:NSTextAlignmentLeft];
        [_registerTimeLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_registerTimeLabel];
    }
    return self;
}

-(void)load{
    
}

@end
