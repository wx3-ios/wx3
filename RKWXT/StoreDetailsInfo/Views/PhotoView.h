//
//  PhotoView.h
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoView;
@protocol PhotoViewDelegate <NSObject>
- (void)photoCheckStoreInfoWithIndex:(PhotoView*)photo  index:(int)Index;
@end


@interface PhotoView : UIView

@property (nonatomic,strong)NSArray *photoCount;
@property (nonatomic,strong)NSMutableArray *photoImageArr;
@property (nonatomic,strong)UIImageView *photoImage;
@property (nonatomic,weak)id <PhotoViewDelegate> delegate;

@end
