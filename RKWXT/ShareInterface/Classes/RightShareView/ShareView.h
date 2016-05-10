//
//  ShareView.h
//  test
//
//  Created by app on 16/4/20.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShareViewDelegate;

@interface ShareView : UIView
@property (nonatomic,weak)id <ShareViewDelegate> delegate;
- (void)addSuperView:(UIView*)supView;
@end

@protocol ShareViewDelegate <NSObject>
- (void)shareViewClickBtnTag:(NSInteger)tag;
@end