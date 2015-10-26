//
//  GoodsInfoDownView.h
//  RKWXT
//
//  Created by SHB on 15/10/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

@interface GoodsInfoDownView : WXUIView
@property (nonatomic,strong) NSArray *dataArr;

//frame外部调用只能设置一次frame
-(void)showDownView:(CGFloat)downViewHeight toDestview:(UIView*)destView;

@end
