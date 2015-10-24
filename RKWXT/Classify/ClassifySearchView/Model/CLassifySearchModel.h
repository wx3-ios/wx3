//
//  CLassifySearchModel.h
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

typedef enum{
    Search_Type_Goods = 1,
    Search_Type_Shop,
}Search_Type;

@protocol CLassifySearchModelDelegate;

@interface CLassifySearchModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *searchResultArr;
@property (nonatomic,assign) Search_Type searchType;
@property (nonatomic,assign) id<CLassifySearchModelDelegate>delegate;
-(void)classifySearchWith:(NSString*)searchStr;

@end

@protocol CLassifySearchModelDelegate <NSObject>
-(void)classifySearchResultSucceed;

@end
