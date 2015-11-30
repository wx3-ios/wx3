//
//  WXCityListLocationCell.m
//  RKWXT
//
//  Created by SHB on 15/11/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXCityListLocationCell.h"

@interface WXCityListLocationCell(){
    WXUIButton *locationBtn;
}
@end

@implementation WXCityListLocationCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = (IPHONE_SCREEN_WIDTH-9-4*xOffset)/3;
        CGFloat btnHeight = 30;
        locationBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.frame = CGRectMake(xOffset, (44-btnHeight)/2, btnWidth, btnHeight);
        [locationBtn setBackgroundColor:[UIColor whiteColor]];
        [locationBtn.titleLabel setFont:WXFont(13.0)];
        [locationBtn setTitleColor:WXColorWithInteger(0xa0a0a0) forState:UIControlStateNormal];
        [locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [locationBtn setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xf6f6f6)];
        [locationBtn addTarget:self action:@selector(gotoLocationCity) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:locationBtn];
    }
    return self;
}

-(void)load{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [locationBtn setTitle:userObj.userLocationCity forState:UIControlStateNormal];
}

-(void)gotoLocationCity{
    if(_delegate && [_delegate respondsToSelector:@selector(wxCityListLocationCellBtnCLicked)]){
        [_delegate wxCityListLocationCellBtnCLicked];
    }
}

@end
