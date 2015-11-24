//
//  WXUserCurrentCityCell.m
//  RKWXT
//
//  Created by SHB on 15/11/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUserCurrentCityCell.h"

@interface WXUserCurrentCityCell(){
    WXUIButton *cityBtn1;
    WXUIButton *cityBtn2;
    WXUIButton *cityBtn3;
}
@end

@implementation WXUserCurrentCityCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = (IPHONE_SCREEN_WIDTH-15-4*xOffset)/3;
        CGFloat btnHeight = 30;
        cityBtn1 = [WXUIButton buttonWithType:UIButtonTypeCustom];
        cityBtn1.frame = CGRectMake(xOffset, (44-btnHeight)/2, btnWidth, btnHeight);
        [cityBtn1 setBackgroundColor:[UIColor whiteColor]];
        [cityBtn1.titleLabel setFont:WXFont(13.0)];
        cityBtn1.tag = 1;
        [cityBtn1 setHidden:YES];
        [cityBtn1 setTitleColor:WXColorWithInteger(0xa0a0a0) forState:UIControlStateNormal];
        [cityBtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [cityBtn1 setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xf6f6f6)];
        [cityBtn1 addTarget:self action:@selector(gotoLocationCity:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cityBtn1];
        
        xOffset += btnWidth+10;
        cityBtn2 = [WXUIButton buttonWithType:UIButtonTypeCustom];
        cityBtn2.frame = CGRectMake(xOffset, (44-btnHeight)/2, btnWidth, btnHeight);
        [cityBtn2 setBackgroundColor:[UIColor whiteColor]];
        [cityBtn2.titleLabel setFont:WXFont(13.0)];
        cityBtn2.tag = 2;
        [cityBtn2 setHidden:YES];
        [cityBtn2 setTitleColor:WXColorWithInteger(0xa0a0a0) forState:UIControlStateNormal];
        [cityBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [cityBtn2 setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xf6f6f6)];
        [cityBtn2 addTarget:self action:@selector(gotoLocationCity:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cityBtn2];
        
        xOffset += btnWidth+10;
        cityBtn3 = [WXUIButton buttonWithType:UIButtonTypeCustom];
        cityBtn3.frame = CGRectMake(xOffset, (44-btnHeight)/2, btnWidth, btnHeight);
        [cityBtn3 setBackgroundColor:[UIColor whiteColor]];
        [cityBtn3.titleLabel setFont:WXFont(13.0)];
        cityBtn3.tag = 3;
        [cityBtn3 setHidden:YES];
        [cityBtn3 setTitleColor:WXColorWithInteger(0xa0a0a0) forState:UIControlStateNormal];
        [cityBtn3 setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [cityBtn3 setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xf6f6f6)];
        [cityBtn3 addTarget:self action:@selector(gotoLocationCity:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cityBtn3];
    }
    return self;
}

-(void)load{
    NSArray *currentCity = self.cellInfo;
    NSInteger number = [currentCity count];
    if(number == 0){
        [cityBtn1 setHidden:YES];
        [cityBtn2 setHidden:YES];
        [cityBtn3 setHidden:YES];
    }
    if(number == 1){
        [cityBtn1 setHidden:NO];
        [cityBtn2 setHidden:YES];
        [cityBtn3 setHidden:YES];
        [cityBtn1 setTitle:[currentCity objectAtIndex:0] forState:UIControlStateNormal];
    }
    if(number == 2){
        [cityBtn1 setHidden:NO];
        [cityBtn2 setHidden:NO];
        [cityBtn3 setHidden:YES];
        [cityBtn1 setTitle:[currentCity objectAtIndex:0] forState:UIControlStateNormal];
        [cityBtn2 setTitle:[currentCity objectAtIndex:1] forState:UIControlStateNormal];
    }
    if(number == 3){
        [cityBtn1 setHidden:NO];
        [cityBtn2 setHidden:NO];
        [cityBtn3 setHidden:NO];
        [cityBtn1 setTitle:[currentCity objectAtIndex:0] forState:UIControlStateNormal];
        [cityBtn2 setTitle:[currentCity objectAtIndex:1] forState:UIControlStateNormal];
        [cityBtn3 setTitle:[currentCity objectAtIndex:2] forState:UIControlStateNormal];
    }
}

-(void)gotoLocationCity:(WXUIButton*)btn{
    NSInteger count = btn.tag;
    if(_delegate && [_delegate respondsToSelector:@selector(userCurrentCityCellBtnClicked:)]){
        [_delegate userCurrentCityCellBtnClicked:count];
    }
}

@end
