//
//  LMSellerClassifyDropListView.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

#define K_Notification_Name_LMSellerDropList_MaskviewClicked @"K_Notification_Name_LMSellerDropList_MaskviewClicked"

@protocol LMSellerClassifyDropListViewDelegate;
@interface LMSellerClassifyDropListView : WXUIView
@property (nonatomic,assign) id<LMSellerClassifyDropListViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame menuButton:(WXUIButton*)menuButton dropListFrame:(CGRect)dropListFrame withData:(NSArray*)dataArr;;
-(void)unshow:(BOOL)animated;

@end

@protocol LMSellerClassifyDropListViewDelegate <NSObject>
-(void)changeSellerName:(id)entity;

@end
