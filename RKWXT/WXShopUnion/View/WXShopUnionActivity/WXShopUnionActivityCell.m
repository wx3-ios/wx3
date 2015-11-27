//
//  WXShopUnionActivityCell.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionActivityCell.h"
#import "WXRemotionImgBtn.h"
#import "WXShopUnionDef.h"

@interface WXShopUnionActivityCell()<WXRemotionImgBtnDelegate>{
    WXRemotionImgBtn *imgView;
}
@end

@implementation WXShopUnionActivityCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, ShopUnionActivityRowHeight)];
        [imgView setUserInteractionEnabled:YES];
        [imgView setDelegate:self];
        [self.contentView addSubview:imgView];
    }
    return self;
}

-(void)load{
    //http://oldyun.67call.com/wx3/Public/Uploads/20151118/20151118141738_576969.jpeg,
//http://oldyun.67call.com/wx3/Public/Uploads/20151118/20151118141759_471740.jpeg
    NSString *imgUrl = self.cellInfo;
    [imgView setCpxViewInfo:@"http://oldyun.67call.com/wx3/Public/Uploads/20151118/20151118141738_576969.jpeg"];
    [imgView load];
}

-(void)buttonImageClicked:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(wxShopUnionActivityCellClicked)]){
        [_delegate wxShopUnionActivityCellClicked];
    }
}

@end
