//
//  PersonSexVC.h
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

@protocol PersonaSexSelectDelegate;
@interface PersonSexVC : WXUIViewController
@property (nonatomic,assign) NSInteger sexSelectedIndex;
@property (nonatomic,assign) id<PersonaSexSelectDelegate>delegate;

@end

@protocol PersonaSexSelectDelegate <NSObject>
-(void)didSelectAtIndex:(NSInteger)index;

@end
