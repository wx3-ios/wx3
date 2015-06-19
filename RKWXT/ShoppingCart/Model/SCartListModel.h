//
//  SCartListModel.h
//  RKWXT
//
//  Created by SHB on 15/6/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

#define D_Notification_LoadShoppingCartList_Succeed @"D_Notification_LoadShoppingCartList_Succeed"
#define D_Notification_LoadShoppingCartList_Failed  @"D_Notification_LoadShoppingCartList_Failed"
#define D_Notification_DeleteOneGoodsInShoppingCartList_Succeed @"D_Notification_DeleteOneGoodsInShoppingCartList_Succeed"
#define D_Notification_DeleteOneGoodsInShoppingCartList_Failed  @"D_Notification_DeleteOneGoodsInShoppingCartList_Failed"

@interface SCartListModel : T_HPSubBaseModel
@property (nonatomic,readonly) NSArray *shoppingCartListArr;

+(SCartListModel*)shareShoppingCartModel;
-(void)loadShoppingCartList;
-(void)insertOneGoodsInShoppingCartList:(NSDictionary*)listDic;
-(void)deleteOneGoodsInShoppingCartList:(NSInteger)cartID;

-(BOOL)shouldDataReload;

@end
