//
//  LMOrderInfoContactShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoContactShopCell.h"

@implementation LMOrderInfoContactShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat btnWidth = 150;
        CGFloat btnHeight = 35;
        CGFloat xOffset = 15;
        WXUIButton *callBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth-xOffset, (LMOrderInfoContactShopCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [callBtn setBackgroundColor:[UIColor whiteColor]];
        [callBtn setBorderRadian:3.0 width:1.0 color:[UIColor grayColor]];
        [callBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        [callBtn setTitleColor:WXColorWithInteger(0x434343) forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callBtn];
    }
    return self;
}

-(void)load{
    
}

-(void)callBtnClicked{
    
}

@end
