//
//  BaseInfoHeadCell.m
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseInfoHeadCell.h"

@interface BaseInfoHeadCell(){
    UIImageView *headImg;
}

@end

@implementation BaseInfoHeadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 18;
        CGFloat headImgWith = 60;
        headImg = [[UIImageView alloc] init];
        headImg.frame = CGRectMake(size.width-xOffset-headImgWith-10, (81-headImgWith)/2, headImgWith, headImgWith);
        [headImg setBorderRadian:30.0 width:1.0 color:[UIColor clearColor]];
        [headImg setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:headImg];
    }
    return self;
}

-(void)load{
    [headImg setImage:[UIImage imageNamed:@"PersonalInfoHeadImg.jpg"]];
    if(_img){
        [headImg setImage:_img];
    }
}

@end
