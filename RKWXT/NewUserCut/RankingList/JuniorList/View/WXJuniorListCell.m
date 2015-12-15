//
//  WXJuniorListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXJuniorListCell.h"
#import "WXRemotionImgBtn.h"
#import "JuniorListEntity.h"
#import "WXKeyPadModel.h"
#import "SysContacterEntityEx.h"

@interface WXJuniorListCell(){
    WXUIButton *numberBtn;
    WXRemotionImgBtn *imgView;
    WXUILabel *nickName;
    WXUILabel *userPhone;
    WXUILabel *juniorNumber;
    WXKeyPadModel *_model;
}
@end

@implementation WXJuniorListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _model = [[WXKeyPadModel alloc] init];
        [_model searchContacter:@"1"];
        
        CGFloat numBtnWidth = 40;
        CGFloat numBtnHeight = 44;
        numberBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        numberBtn.frame = CGRectMake(0, (WXJuniorListCellHeight-numBtnHeight)/2, numBtnWidth, numBtnHeight);
        [numberBtn setBackgroundColor:[UIColor clearColor]];
        [numberBtn setEnabled:NO];
        [numberBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [self.contentView addSubview:numberBtn];
        
        CGFloat xOffset = numBtnWidth;
        CGFloat imgViewWidth = 42;
        CGFloat imgViewHeight = imgViewWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (WXJuniorListCellHeight-imgViewHeight)/2, imgViewWidth, imgViewHeight)];
        [imgView setBorderRadian:imgViewWidth/2 width:1.0 color:[UIColor clearColor]];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgViewWidth+8;
        CGFloat yOffset = 10;
        CGFloat juniorNumLabelWidth = 50;
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
        
        yOffset += labelHeight+6;
        userPhone = [[WXUILabel alloc] init];
        userPhone.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [userPhone setBackgroundColor:[UIColor clearColor]];
        [userPhone setTextAlignment:NSTextAlignmentLeft];
        [userPhone setTextColor:WXColorWithInteger(0x000000)];
        [userPhone setFont:WXFont(14.0)];
        [self.contentView addSubview:userPhone];
        
        WXUIImageView *userHeaderImgView = [[WXUIImageView alloc] init];
        userHeaderImgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-juniorNumLabelWidth-juniorHeaderViewWidth, (WXJuniorListCellHeight-juniorHeaderViewHeight)/2, juniorHeaderViewWidth, juniorHeaderViewHeight);
        [userHeaderImgView setImage:[UIImage imageNamed:@"JuniorListUserHeadImg.png"]];
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
    JuniorListEntity *entity = self.cellInfo;
    
    if(entity.rankingNum == 1){
        [numberBtn setImage:[UIImage imageNamed:@"JuniorNumChampion.png"] forState:UIControlStateNormal];
        [numberBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if(entity.rankingNum == 2){
        [numberBtn setImage:[UIImage imageNamed:@"JuniorNumSecond.png"] forState:UIControlStateNormal];
        [numberBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if(entity.rankingNum == 3){
        [numberBtn setImage:[UIImage imageNamed:@"JuniorNumThird.png"] forState:UIControlStateNormal];
        [numberBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if(entity.rankingNum > 3){
        [numberBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [numberBtn setTitle:[NSString stringWithFormat:@"%ld",(long)entity.rankingNum] forState:UIControlStateNormal];
    }
    
    [imgView setImage:[UIImage imageNamed:@"PersonalInfo.png"]];
    if(![entity.imgUrl isEqualToString:@""] && entity.imgUrl){
        [imgView setCpxViewInfo:entity.imgUrl];
        [imgView load];
    }
    
    [nickName setText:[NSString stringWithFormat:@"%ld",(long)entity.wxID]];
    if(![entity.nickName isEqualToString:@""] && entity.nickName){
        [nickName setText:[NSString stringWithFormat:@"%@(ID:%ld)",entity.nickName,(long)entity.wxID]];
    }
    [userPhone setText:[self userPhoneChangedWithOldStr:entity.phone]];
    [juniorNumber setText:[NSString stringWithFormat:@"%ld",(long)entity.clientNums]];
}

-(NSString*)userPhoneChangedWithOldStr:(NSString*)oldStr{
    if(!oldStr){
        return nil;
    }
//    NSString *userName = [self searchPhoneNameWithUserPhone:oldStr];
//    if(![userName isEqualToString:oldStr]){
//        return [NSString stringWithFormat:@"%@(%@)",userName,oldStr];
//    }
    
    NSString *newStr = nil;
    newStr = [oldStr substringWithRange:NSMakeRange(0, 3)];
    newStr = [newStr stringByAppendingString:@"****"];
    newStr = [newStr stringByAppendingString:[oldStr substringFromIndex:7]];
    return newStr;
}

//根据手机号匹配用户名，如果未匹配到返回手机号
-(NSString*)searchPhoneNameWithUserPhone:(NSString*)phone{
    if(!phone){
        return nil;
    }
    for(SysContacterEntityEx *entity in _model.contacterFilter){
        for(NSString *phoneStr in entity.contactEntity.phoneNumbers){
            NSString *newPhoneStr = [UtilTool callPhoneNumberRemovePreWith:phoneStr];
            if([phone isEqualToString:newPhoneStr]){
                return entity.contactEntity.fullName?entity.contactEntity.fullName:phoneStr;
            }
        }
    }
    return phone;
}

@end
