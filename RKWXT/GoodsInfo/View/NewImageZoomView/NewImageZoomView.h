//
//  NewImageZoomView.h
//  RKWXT
//
//  Created by SHB on 15/9/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

@interface NewImageZoomView : WXUIView
-(id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size;
@property (nonatomic,strong) NSArray *imgs;

-(void)updateImageDate:(NSArray*)imageArr selectIndex:(NSInteger)index;

@end
