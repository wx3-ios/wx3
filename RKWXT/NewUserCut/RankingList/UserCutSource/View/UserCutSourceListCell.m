//
//  UserCutSourceListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutSourceListCell.h"
#import "WXRemotionImgBtn.h"

@interface UserCutSourceListCell(){
    WXUILabel *timeLabel;
    WXRemotionImgBtn *imgView;
    WXUILabel *moneyLabel;
    WXUILabel *textLabel;
}
@end

@implementation UserCutSourceListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = IPHONE_SCREEN_WIDTH/3;
        
    }
    return self;
}

-(void)load{
    
}

@end
