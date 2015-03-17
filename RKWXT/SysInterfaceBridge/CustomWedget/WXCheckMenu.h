//
//  WXCheckMenu.h
//  CallTesting
//
//  Created by le ting on 5/17/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIView.h"

@protocol WXCheckMenuDelegate;
@interface WXCheckMenu : WXUIView
@property (nonatomic,assign)id<WXCheckMenuDelegate>delegate;
//titles normalImgArray selectedImgArray 必须要一一对应 并且image的大小要一致
+ (id)checkMenuWithTitleArray:(NSArray*)titles normalImageArray:(NSArray*)normalImgArray selectedImageArray:(NSArray*)selectedImgArray;
- (void)setSelectedAtIndex:(NSInteger)index;
- (NSInteger)selectedIndex;
@end

@protocol WXCheckMenuDelegate <NSObject>
- (void)menuButtonClickAtIndex:(NSInteger)index;
@end
