//
//  WXShopUnionAreaListView.m
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionAreaListView.h"
#import "WXRemotionImgBtn.h"
#import "WXShopUnionAreaListCell.h"

@interface WXShopUnionAreaListView(){
    WXUIButton *_areaBtn;
}
@end

@implementation WXShopUnionAreaListView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _areaBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _areaBtn.frame = CGRectMake(0, 0, (IPHONE_SCREEN_WIDTH-4*10)/3, 30);
        [_areaBtn setBackgroundColor:[UIColor whiteColor]];
        [_areaBtn setBorderRadian:1.0 width:1.0 color:[UIColor colorWithRed:0.131 green:0.943 blue:0.217 alpha:1.000]];
        [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_areaBtn addTarget:self action:@selector(areaListClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_areaBtn];
    }
    return self;
}

-(void)areaListClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[WXShopUnionAreaListCell class]]);
    if(superView && [superView isKindOfClass:[WXShopUnionAreaListCell class]]){
        WXShopUnionAreaListCell *cell = (WXShopUnionAreaListCell*)superView;
        id<WXShopUnionAreaListCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(shopUnionAreaClicked:)]){
            [delegate shopUnionAreaClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    NSString *sname = self.cpxViewInfo;
    [_areaBtn setTitle:sname forState:UIControlStateNormal];
    
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if([sname isEqualToString:userObj.userLocationArea]){
        [_areaBtn setBorderRadian:1.0 width:1.0 color:[UIColor colorWithRed:0.971 green:0.124 blue:0.038 alpha:1.000]];
    }else{
        [_areaBtn setBorderRadian:1.0 width:1.0 color:[UIColor colorWithRed:0.131 green:0.943 blue:0.217 alpha:1.000]];
    }
}

@end