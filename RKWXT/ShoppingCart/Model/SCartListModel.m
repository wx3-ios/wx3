//
//  SCartListModel.m
//  RKWXT
//
//  Created by SHB on 15/6/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "SCartListModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "ShoppingCartEntity.h"

@interface SCartListModel(){
    NSMutableArray *_shoppingCartListArr;
}
@end

@implementation SCartListModel

+(SCartListModel*)shareShoppingCartModel{
    static dispatch_once_t onceToken;
    static SCartListModel *shareInstance = nil;
    dispatch_once(&onceToken,^{
        shareInstance = [[SCartListModel alloc] init];
    });
    return shareInstance;
}

-(id)init{
    if(self = [super init]){
        _shoppingCartListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

-(void)toInit{
    [super toInit];
    [_shoppingCartListArr removeAllObjects];
}

-(void)parseShoppingCartList:(NSDictionary*)jsonDic{
    if(!jsonDic){
        return;
    }
    [_shoppingCartListArr removeAllObjects];
    NSArray *arr = [jsonDic objectForKey:@"data"];
    for(NSDictionary *dic in arr){
        ShoppingCartEntity *entity = [ShoppingCartEntity initShoppingCartDataWithDictionary:dic];
        NSString *smallImgStr = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.smallImg];
        entity.smallImg = smallImgStr;
        [_shoppingCartListArr addObject:entity];
    }
}

//查询
-(void)loadShoppingCartList{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", [NSNumber numberWithInt:2], @"type", nil];
    __block SCartListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_LoadShoppingCartList_Failed object:retData.errorDesc];
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseShoppingCartList:retData.data];
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_LoadShoppingCartList_Succeed object:nil];
        }
    }];
}

//添加购物车成功后在本地加入数据
-(void)insertOneGoodsInShoppingCartList:(NSDictionary *)listDic{
    if(!listDic){
        return;
    }
    ShoppingCartEntity *entity = [ShoppingCartEntity initShoppingCartDataWithDictionary:listDic];
    NSString *smallImgStr = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.smallImg];
    entity.smallImg = smallImgStr;
    [_shoppingCartListArr addObject:entity];
}

//删除
-(BOOL)parseAfterDeleteGoodsInShoppingCartList:(NSInteger)cartID{
    for(ShoppingCartEntity *entity in _shoppingCartListArr){
        if(entity.cart_id == cartID){
            [_shoppingCartListArr removeObject:entity];
            return YES;
        }
    }
    return NO;
}

-(void)deleteOneGoodsInShoppingCartList:(NSInteger)cartID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", [NSNumber numberWithInt:4], @"type", [NSNumber numberWithInt:(int)cartID],@"cart_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_DeleteOneGoodsInShoppingCartList_Failed object:retData.errorDesc];
        }else{
            BOOL succeed = [self parseAfterDeleteGoodsInShoppingCartList:cartID];
            if(succeed){
                [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_DeleteOneGoodsInShoppingCartList_Succeed object:nil];
            }
        }
    }];
}

@end
