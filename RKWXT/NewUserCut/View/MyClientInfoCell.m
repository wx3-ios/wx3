//
//  MyClientInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/9/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientInfoCell.h"
#import "WXRemotionImgBtn.h"
#import "MyClientEntity.h"

#define IconImgWidth 52

@interface MyClientInfoCell(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_companyLabel;
    WXUILabel *_moneyLabel;
    WXUILabel *_registerTimeLabel;
}
@end

@implementation MyClientInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat imgWidth = IconImgWidth;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        yOffset += 6;
        CGFloat nameWidth = 200;
        CGFloat nameHight = 20;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += nameHight+5;
        _companyLabel = [[WXUILabel alloc] init];
        _companyLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHight);
        [_companyLabel setBackgroundColor:[UIColor clearColor]];
        [_companyLabel setTextColor:WXColorWithInteger(0x000000)];
        [_companyLabel setTextAlignment:NSTextAlignmentLeft];
        [_companyLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_companyLabel];
        
        CGFloat xGap = 15;
        yOffset += nameHight+8;
        CGFloat textWidth = 70;
        CGFloat textHeight = 20;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xGap, yOffset, textWidth, textHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setFont:WXFont(14.0)];
        [textLabel setText:@"我的提成:"];
        [textLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:textLabel];
        
        xGap += textWidth;
        _moneyLabel = [[WXUILabel alloc] init];
        _moneyLabel.frame = CGRectMake(xOffset, yOffset, textWidth, textHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_moneyLabel setTextAlignment:NSTextAlignmentLeft];
        [_moneyLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_moneyLabel];
        
        yOffset += textHeight;
        _registerTimeLabel = [[WXUILabel alloc] init];
        _registerTimeLabel.frame = CGRectMake(13, yOffset, 150, textHeight);
        [_registerTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_registerTimeLabel setTextColor:WXColorWithInteger(0xababab)];
        [_registerTimeLabel setTextAlignment:NSTextAlignmentLeft];
        [_registerTimeLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_registerTimeLabel];
    }
    return self;
}

-(void)load{
    MyClientEntity *entity = self.cellInfo;
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfoHeadImg.jpg"];
    [_imgView setImage:iconImg];
    if(![entity.userIconImg isEqualToString:AllImgPrefixUrlString] && entity.userIconImg){
        [_imgView setCpxViewInfo:entity.userIconImg];
        [_imgView load];
    }
    [_imgView setBorderRadian:IconImgWidth/2 width:1.0 color:[UIColor clearColor]];
    
    NSString *nameText = [NSString stringWithFormat:@"%ld",(long)entity.userID];
    if(entity.nickName.length != 0){
        nameText = [NSString stringWithFormat:@"%@ (%ld)",entity.nickName,(long)entity.userID];
    }
    [_nameLabel setText:nameText];
    [_companyLabel setText:[self userPhoneChangedWithOldStr:entity.userPhone]];
    [_moneyLabel setText:[NSString stringWithFormat:@"  ￥%.2f",entity.cutMoney]];
    [_registerTimeLabel setText:[NSString stringWithFormat:@"注册时间: %@",[UtilTool getDateTimeFor:entity.registTime type:2]]];
}

-(NSString*)userPhoneChangedWithOldStr:(NSString*)oldStr{
    if(!oldStr){
        return nil;
    }
    if(oldStr.length != 11){
        return nil;
    }
    
    NSString *newStr = nil;
    newStr = [oldStr substringWithRange:NSMakeRange(0, 3)];
    newStr = [newStr stringByAppendingString:@"****"];
    newStr = [newStr stringByAppendingString:[oldStr substringFromIndex:7]];
    return newStr;
}

@end
