//
//  WXTWebViewController.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTWebViewController : BaseVC
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * requestUrl;
-(id)initWithURL:(NSString *)url;
-(id)initWithURL:(NSString *)url title:(NSString*)title;
@end
