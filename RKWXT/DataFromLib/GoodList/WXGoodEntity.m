//
//  WXGoodEntity.m
//  Woxin2.0
//
//  Created by le ting on 8/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXGoodEntity.h"
#import "PinYinSearchOBJ.h"
//#import "T_GoodInfoEntity.h"

@implementation WXGoodEntity

- (void)dealloc{
//    [super dealloc];
}

+ (WXGoodEntity*)goodWithDictionary:(NSDictionary*)goodDic domain:(NSString*)domain{
    if(!goodDic || !domain || [domain length] ==0){
        return nil;
    }
    
    NSString *goodIDStr = [goodDic objectForKey:@"group_id"];
    if(!goodIDStr){
        KFLog_Normal(YES, @"无效的商品ID");
        return nil;
    }
    
    NSInteger goodID = [goodIDStr integerValue];
    if(goodID <= 0){
        KFLog_Normal(YES, @"无效的商品ID");
        return nil;
    }
    
    return [[self alloc] initWithGoodDic:goodDic domain:domain] ;
}

- (id)initWithGoodDic:(NSDictionary*)goodDic domain:(NSString*)domain{
    if(self = [super init]){
        NSString *des = [goodDic objectForKey:@"description"];
        [self setDesc:des];
        NSString *categoryStr = [goodDic objectForKey:@"group_id"];
        if(!categoryStr){
            KFLog_Normal(YES, @"商品分类为空");
        }else{
            NSInteger category = [categoryStr integerValue];
            if(category > 0){
                [self setCategory:category];
            }else{
                KFLog_Normal(YES, @"无效的商品分类");
            }
        }
        
        NSString *listImgURL = [self imageURLFrom:[goodDic objectForKey:@"home_img"] domain:domain];
        [self setListImgURL:listImgURL];
        
        NSInteger goodID = [[goodDic objectForKey:@"id"] integerValue];
        [self setGoodID:goodID];
        
        [self setIsHome:[[goodDic objectForKey:@"is_home"] boolValue]];
        [self setIsHot:[[goodDic objectForKey:@"is_hot"] boolValue]];
        [self setIsRecommend:[[goodDic objectForKey:@"is_puls"] boolValue]];
        [self setFavCount:[[goodDic objectForKey:@"like_count"] integerValue]];
        NSString *topImgURL = [self imageURLFrom:[goodDic objectForKey:@"main_img"] domain:domain];
        [self setTopImageURL:topImgURL];
        [self setMarketPrice:[[goodDic objectForKey:@"market_price"] floatValue]];
        [self setName:[goodDic objectForKey:@"name"]];
        [self setShopPrice:[[goodDic objectForKey:@"shop_price"] floatValue]];
        [self setDetailImgURLArray:[self detailImageURLFrom:[goodDic objectForKey:@"info_img"] domain:domain]];
        [self setIsInGuess:[[goodDic objectForKey:@"is_like"] integerValue]];
		[self setSortIndex:[[goodDic objectForKey:@"sort"] unsignedIntegerValue]];
		[self setUnit:[goodDic objectForKey:@"meterage_name"]];
    }
    return self;
}

- (NSArray*)detailImageURLFrom:(NSString*)string domain:(NSString*)domain{
    if(!string){
        return nil;
    }
    NSArray *subStringArray = [string componentsSeparatedByString:@","];
    NSMutableArray *subURLArray = [NSMutableArray array];
    for(NSString *subString in subStringArray){
        NSString *subURL = [self imageURLFrom:subString domain:domain];
        if(subURL){
            [subURLArray addObject:subURL];
        }
    }
    if([subURLArray count] > 0){
        return subURLArray;
    }
    return nil;
}

- (NSString*)imageURLFrom:(NSString*)subImageURL domain:(NSString*)domain{
    NSString *url = nil;
    if(!subImageURL || !domain){
        KFLog_Normal(YES, @"无效的图片地址");
    }else{
        if([domain hasSuffix:@"/"]){
            NSInteger lengh = [subImageURL length];
            domain = [domain substringToIndex:lengh -1];
        }
        if([subImageURL hasPrefix:@"/"]){
            subImageURL = [subImageURL substringFromIndex:1];
        }
        url = [NSString stringWithFormat:@"%@/%@",domain,subImageURL];
    }
    return url;
}

- (BOOL)matchString:(NSString*)str{
    if(!str){
        return NO;
    }
    if(!_name){
        return NO;
    }
    
    BOOL ret = [PinYinSearchOBJ isIncludeString:str inString:_name];
    return ret;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"good name=%@,ID=%d index=%u isInGuess=%d",_name,(int)_goodID,self.sortIndex,_isInGuess];
}

- (NSString*)marketPriceString{
    return [self marketPriceStringWithFloatPointHidden:NO];
}

- (NSString*)shopPriceString{
    return [self shopPriceStringWithFloatPointHidden:NO];
}

- (NSString*)marketPriceStringWithFloatPointHidden:(BOOL)hidden{
//	if (_marketPrice > kMaxPrice){
//		return @"";
//	}
	
	NSString *fString = [UtilTool convertFloatToString:_marketPrice];
	fString = [NSString stringWithFormat:@"￥%@",fString];
	if (_unit){
		fString = [NSString stringWithFormat:@"%@/%@",fString,_unit];
	}
	return fString;
}

- (NSString*)shopPriceStringWithFloatPointHidden:(BOOL)hidden{
//	if (_shopPrice > kMaxPrice){
//		return @"";
//	}
	
	NSString *fString = [UtilTool convertFloatToString:_shopPrice];
	fString = [NSString stringWithFormat:@"￥%@",fString];
	if (_unit){
		fString = [NSString stringWithFormat:@"%@/%@",fString,_unit];
	}
	
	return fString;
}

@end
