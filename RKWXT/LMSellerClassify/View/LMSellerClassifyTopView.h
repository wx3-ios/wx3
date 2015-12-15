//
//  LMSellerClassifyTopView.h
//  RKWXT
//
//  Created by SHB on 15/12/14.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

#define K_Notfication_Name_SellerClassifyBtnClicked @"K_Notfication_Name_SellerClassifyBtnClicked"

#define K_Notfication_Name_SellerClassifyDropListOpen @"K_Notfication_Name_SellerClassifyDropListOpen"
#define K_Notfication_Name_SellerClassifyDropListClose @"K_Notfication_Name_SellerClassifyDropListClose"

@interface LMSellerClassifyTopView : WXUIView

-(void)initClassifySellerArr:(NSArray*)classifyArr;

@end
