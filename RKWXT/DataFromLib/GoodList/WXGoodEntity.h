//
//  WXGoodEntity.h
//  Woxin2.0
//
//  Created by le ting on 8/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class T_GoodInfoEntity;
@interface WXGoodEntity : NSObject
@property (nonatomic,retain)NSString *desc; //商品描述
@property (nonatomic,assign)NSInteger goodID;//商品ID
@property (nonatomic,retain)NSString *name;//名称
@property (nonatomic,assign)NSInteger soldNumber;//已售个数~
@property (nonatomic,assign)NSInteger category; //类别
@property (nonatomic,retain)NSString *listImgURL; //列表图片
@property (nonatomic,retain)NSArray *detailImgURLArray; //商品详情图片
@property (nonatomic,retain)NSString *topImageURL;//商城顶部图片
@property (nonatomic,assign)BOOL isHome;//是否为主页显示
@property (nonatomic,assign)BOOL isHot;//是否为热卖
@property (nonatomic,assign)BOOL isRecommend;//是否为推荐
@property (nonatomic,assign)NSInteger favCount;//喜欢的个数
@property (nonatomic,assign)CGFloat marketPrice;//商城价格
@property (nonatomic,assign)CGFloat shopPrice;//商店价格
@property (nonatomic,assign)BOOL isInGuess;//是否在猜你喜欢的列表中
@property (nonatomic,assign)NSUInteger sortIndex;//商品排序
@property (nonatomic,retain)NSString *unit;//单位

+ (WXGoodEntity*)goodWithDictionary:(NSDictionary*)goodDic domain:(NSString*)domain;
- (BOOL)matchString:(NSString*)str;

- (NSString*)marketPriceString;
- (NSString*)shopPriceString;
- (NSString*)shopPriceStringWithFloatPointHidden:(BOOL)hidden;
- (NSString*)marketPriceStringWithFloatPointHidden:(BOOL)hidden;

@end