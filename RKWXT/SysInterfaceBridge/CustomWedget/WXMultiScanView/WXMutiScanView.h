//
//  WXMutiScanView.h
//  WXScrollBrowser
//
//  Created by le ting on 6/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIScrollView.h"
#import "WXMutiScanViewCell.h"

//从上到下~ 从左到右
/*index 从上到下自增，从左到右自增
 *当direction = E_MultiScanViewDirection_Horizonal的时候，列为section 行为row
 *当direction = E_MultiScanViewDirection_Vertical的时候 行为section 列为row
 */
typedef enum {
    //水平的~
    E_MultiScanViewDirection_Horizonal,
    //垂直的~
    E_MultiScanViewDirection_Vertical,
}E_MultiScanViewDirection;

@protocol WXMutiScanViewDataSource;
@protocol WXMutiScanViewDelegate;
@interface WXMutiScanView : WXUIView
@property (nonatomic,assign)id<WXMutiScanViewDataSource>dataSource;
@property (nonatomic,assign)id<WXMutiScanViewDelegate>delegate;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (id)initWithFrame:(CGRect)frame direction:(E_MultiScanViewDirection)direction;
@end

@protocol WXMutiScanViewDataSource <NSObject>
- (WXMutiScanViewCell *)multiScanView:(WXMutiScanView *)multiScanView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInMutiScanView:(WXMutiScanView *)multiScanView;
#pragma mark UIScrollViewDelegate

@optional
//默认为1
- (NSInteger)multiScanView:(WXMutiScanView *)multiScanView numberOfRowsInSection:(NSInteger)section;
@end

@protocol WXMutiScanViewDelegate <NSObject>
//section的高度~
- (CGFloat)multiScanView:(WXMutiScanView*)mutiScanView heightForSection:(NSInteger)section;
//row的高度~
- (CGFloat)multiScanView:(WXMutiScanView *)multiScanView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
//默认为0
- (CGFloat)multiScanView:(WXMutiScanView *)multiScanView heightForHeaderInSection:(NSInteger)section;
//默认为NO
- (BOOL)pagingEnable:(WXMutiScanView*)mutiScanView;
@end
