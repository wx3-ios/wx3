//
//  WXJuniorListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXJuniorListCell.h"
#import "WXRemotionImgBtn.h"

@interface WXJuniorListCell(){
    WXUIButton *numberBtn;
    WXRemotionImgBtn *imgView;
    WXUILabel *nickName;
    WXUILabel *userPhone;
    WXUILabel *juniorNumber;
}
@end

@implementation WXJuniorListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat numBtnWidth = 40;
        CGFloat numBtnHeight = 44;
        numberBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        numberBtn.frame = CGRectMake(0, (WXJuniorListCellHeight-numBtnHeight)/2, numBtnWidth, numBtnHeight);
        [numberBtn setBackgroundColor:[UIColor clearColor]];
        [numberBtn setEnabled:NO];
        [self.contentView addSubview:numberBtn];
        
        CGFloat xOffset = numBtnWidth;
        CGFloat imgViewWidth = 42;
        CGFloat imgViewHeight = imgViewWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (WXJuniorListCellHeight-imgViewHeight)/2, imgViewWidth, imgViewHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgViewWidth+8;
        CGFloat yOffset = 10;
        CGFloat juniorNumLabelWidth = 80;
        CGFloat juniorHeaderViewWidth = 24;
        CGFloat juniorHeaderViewHeight = juniorHeaderViewWidth;
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH-juniorNumLabelWidth-10-juniorHeaderViewWidth-10;
        CGFloat labelHeight = 18;
        nickName = [[WXUILabel alloc] init];
        nickName.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [nickName setBackgroundColor:[UIColor clearColor]];
        [nickName setTextAlignment:NSTextAlignmentLeft];
        [nickName setTextColor:WXColorWithInteger(0x000000)];
        [nickName setFont:WXFont(15.0)];
        [self.contentView addSubview:nickName];
        
        yOffset += labelHeight+10;
        userPhone = [[WXUILabel alloc] init];
        userPhone.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [userPhone setBackgroundColor:[UIColor clearColor]];
        [userPhone setTextAlignment:NSTextAlignmentLeft];
        [userPhone setTextColor:WXColorWithInteger(0x000000)];
        [userPhone setFont:WXFont(14.0)];
        [self.contentView addSubview:userPhone];
        
        WXUIImageView *userHeaderImgView = [[WXUIImageView alloc] init];
        userHeaderImgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-juniorNumLabelWidth-juniorHeaderViewWidth, (WXJuniorListCellHeight-juniorHeaderViewHeight)/2, juniorHeaderViewWidth, juniorHeaderViewHeight);
        [userHeaderImgView setImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:userHeaderImgView];
        
        juniorNumber = [[WXUILabel alloc] init];
        juniorNumber.frame = CGRectMake(IPHONE_SCREEN_WIDTH-juniorNumLabelWidth-10, (WXJuniorListCellHeight-labelHeight)/2, juniorNumLabelWidth, labelHeight);
        [juniorNumber setBackgroundColor:[UIColor clearColor]];
        [juniorNumber setTextAlignment:NSTextAlignmentRight];
        [juniorNumber setTextColor:WXColorWithInteger(0x000000)];
        [juniorNumber setFont:WXFont(16.0)];
        [self.contentView addSubview:juniorNumber];
    }
    return self;
}

-(void)load{
    
}

@end
