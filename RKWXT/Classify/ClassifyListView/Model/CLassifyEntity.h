//
//  CLassifyEntity.h
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define goods_home_img @"goods_home_img"
#define goods_name    @"goods_name"
#define goods_id      @"goods_id"

#define cat_name      @"cat_name"
#define cat_img       @"cat_img"
#define cat_id        @"cat_id"

typedef enum{
    Classify_CatType_None = 0,   //没有分类
    Classify_CatType_One,   //一级分类
    Classify_CatType_Two,   //二级分类
}Classify_CatType;

@interface CLassifyEntity : NSObject
@property (nonatomic,strong) NSString *catName;
@property (nonatomic,assign) Classify_CatType catType;
@property (nonatomic,assign) NSInteger catID;
//分类下级数据（可能为分类，也可能为商品）
@property (nonatomic,strong) NSArray *dataArr;
//商品
@property (nonatomic,strong) NSString *goods_Img;
@property (nonatomic,strong) NSString *goods_Name;
@property (nonatomic,assign) NSInteger goods_ID;
//分类
@property (nonatomic,assign) NSString *cat_Name;
@property (nonatomic,strong) NSString *cat_Img;
@property (nonatomic,assign) NSInteger cat_ID;

+(CLassifyEntity*)initClassifyEntityWith:(NSDictionary*)dic;

@end
