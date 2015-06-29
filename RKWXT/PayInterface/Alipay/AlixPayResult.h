//
//  AlixPayResult.h
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlixPayResult : NSObject {
	int		  _statusCode;
	NSString *_statusMessage;
	NSString *_resultString;
	NSString *_signString;
	NSString *_signType;
}

@property(nonatomic, readonly) int statusCode;
@property(nonatomic, readonly) NSString *statusMessage;
@property(nonatomic, readonly) NSString *resultString;
@property(nonatomic, readonly) NSString *signString;
@property(nonatomic, readonly) NSString *signType;

- (id)initWithString:(NSString *)string;

@end
