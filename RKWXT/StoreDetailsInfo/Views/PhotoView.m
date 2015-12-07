//
//  PhotoView.m
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PhotoView.h"
#import "UIViewAdditions.h"

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}


- (void)setPhotoCount:(NSArray *)photoCount{
    _photoCount = photoCount;
    
    self.width = 320;
    self.height = 98;
 
    
    NSInteger count = self.photoCount.count;
    CGFloat imageW = 93;
    CGFloat leftMargin = 10;
    CGFloat margin = (self.width - (count * imageW) - 20 ) / (count - 1);
    for (int i = 0; i < count; i++) {
        UIImageView *photo = [[UIImageView alloc]init];
        
        CGFloat imageX = leftMargin + (i * (imageW + margin));
        
        photo.frame = CGRectMake(imageX, 0, imageW, self.height);
        photo.backgroundColor = [UIColor redColor];
        photo.userInteractionEnabled = YES;
        [self addSubview:photo];
        self.photoImage = photo;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
        [photo addGestureRecognizer:tap];
        tap.view.tag = i;
       
        [self.photoImageArr addObject:self.photoImage];
    }
}

- (void)clickTap:(UITapGestureRecognizer*)tap{
   
    if (_delegate && [_delegate respondsToSelector:@selector(photoCheckStoreInfoWithIndex:index:)]) {
        [self.delegate photoCheckStoreInfoWithIndex:self index:tap.view.tag];
    }
}

- (NSMutableArray*)photoImageArr{
    if (!_photoImageArr) {
        _photoImageArr = [NSMutableArray array];
    }
    return _photoImageArr;
}

@end
