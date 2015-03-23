//
//  WXTWebViewController.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTWebViewController : UIViewController
@property (nonatomic, strong) NSString * requestUrl;
-(id)initWithRequestUrl:(NSString *)url;
@end
