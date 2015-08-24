//
//  WXCommonWebView.h
//  RKWXT
//
//  Created by SHB on 15/8/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

typedef enum{
    WebView_Type_SingleUrl = 0,
    WebView_Type_JointUrl,
}WebView_Type;

@interface WXCommonWebView : WXUIViewController
@property (nonatomic,assign) WebView_Type urlType;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) NSString *webUrlString;

-(id)initCommonWebviewWithFeedType:(WebView_Type)urlType paramDictionary:(NSDictionary*)paramDictionary;

@end
