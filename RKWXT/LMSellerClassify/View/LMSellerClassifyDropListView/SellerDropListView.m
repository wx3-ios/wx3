//
//  SellerDropListView.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "SellerDropListView.h"
#import "WXRemotionImgBtn.h"
#import "LMSellerClassifyDropListCell.h"
#import "ShopUnionClassifyEntity.h"

@interface SellerDropListView(){
    WXUIButton *_sellerBtn;
}
@end

@implementation SellerDropListView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _sellerBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _sellerBtn.frame = CGRectMake(0, (40-25)/2, (IPHONE_SCREEN_WIDTH-5*10)/4, 25);
        [_sellerBtn setBackgroundColor:[UIColor clearColor]];
        [_sellerBtn setTitleColor:WXColorWithInteger(0x9b9b9b) forState:UIControlStateNormal];
        [_sellerBtn addTarget:self action:@selector(sellerListClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sellerBtn];
    }
    return self;
}

-(void)sellerListClicked:(id)sender{
    UIView *superView = self.superview;
    do{
        superView = superView.superview;
    }while (superView && ![superView isKindOfClass:[LMSellerClassifyDropListCell class]]);
    if(superView && [superView isKindOfClass:[LMSellerClassifyDropListCell class]]){
        LMSellerClassifyDropListCell *cell = (LMSellerClassifyDropListCell*)superView;
        id<LMSellerClassifyDropListCellDelegate>delegate = cell.delegate;
        if(delegate && [delegate respondsToSelector:@selector(lmSellerListBtnClicked:)]){
            [delegate lmSellerListBtnClicked:self.cpxViewInfo];
        }
    }else{
        KFLog_Normal(YES, @"没有找到最外层的cell");
    }
}

-(void)load{
    ShopUnionClassifyEntity *entity = self.cpxViewInfo;
    [_sellerBtn setTitle:entity.industryName forState:UIControlStateNormal];
    
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    NSString *name = [userDefault textValueForKey:@"industryName"];
    if([entity.industryName isEqualToString:name]){
        [_sellerBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    }else{
        [_sellerBtn setTitleColor:WXColorWithInteger(0x9b9b9b) forState:UIControlStateNormal];
    }
}

@end