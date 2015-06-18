//
//  WXTMallListWebVC.h
//  RKWXT
//
//  Created by SHB on 15/6/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
#import "WXTURLFeedOBJ.h"

@protocol WXTMallListWebMark;

@interface WXTMallListWebVC : WXUIViewController<WXTMallListWebMark>
@property (nonatomic,strong) NSString *cstTitle;

-(id)initWithFeedType:(WXT_UrlFeed_Type)urlFeedType paramDictionary:(NSDictionary*)paramDictionary;
@end

@protocol WXTMallListWebMark <NSObject>
@optional
-(void)dataLoadedStarted;
-(void)dataLoadedFailed;
-(void)dataLoadedSucceed;
@end
