//
//  AlixLibService.h
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlixPaylibDelegate <NSObject>

-(void)paymentResultDelegate:(NSString *)result;

@end


@interface AlixLibService : NSObject

/**
 *	@brief	标准支付接口
 *
 *	@param 	order 	符合支付宝规则订单信息
 *	@param 	scheme 	应用程序scheme
 *	@param 	seletor  接收结果函数
 *	@param 	target 	接收结果target
 */
+ (void)payOrder:(NSString*)order AndScheme:(NSString*)scheme  seletor:(SEL)seletor target:(id)target;


/**
 * 针对游戏行业全屏情况考虑
 */
+ (void)setFullScreen;

/**
 * 显示StatusBar，根据应用自身情况调用
 */
+ (void)exitFullScreen;

@end
