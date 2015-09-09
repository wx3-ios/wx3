//
//  BaseInfoHeadCell.m
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseInfoHeadCell.h"
#import "WXRemotionImgBtn.h"

@interface BaseInfoHeadCell(){
    WXRemotionImgBtn *headImg;
}

@end

@implementation BaseInfoHeadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 18;
        CGFloat headImgWith = 60;
        headImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(size.width-xOffset-headImgWith-10, (81-headImgWith)/2, headImgWith, headImgWith)];
        [headImg setUserInteractionEnabled:NO];
        [headImg setBorderRadian:30.0 width:1.0 color:[UIColor clearColor]];
        [headImg setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:headImg];
    }
    return self;
}

-(void)load{
    NSString *iconName = self.cellInfo;
    if(_img){
        [headImg setImage:_img];
    }else{
        if(iconName){
            [headImg setCpxViewInfo:iconName];
            [headImg load];
        }else{
            [headImg setImage:[UIImage imageNamed:@"PersonalInfoHeadImg.jpg"]];
        }
    }
}

@end
