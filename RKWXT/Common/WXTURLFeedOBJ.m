//
//  WXTURLFeedOBJ.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ.h"

@implementation WXTURLFeedOBJ

+ (WXTURLFeedOBJ*)sharedURLFeedOBJ{
    static dispatch_once_t onceToken;
    static WXTURLFeedOBJ *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXTURLFeedOBJ alloc] init];
    });
    return sharedInstance;
}

- (NSString*)rootURL:(WXT_UrlFeed_Type)type{
    NSString *url = nil;
    NSString *rootURL = [NSString stringWithFormat:@"https://api.67call.com/agent/call_api.php"];
    NSString *newRootUrl = [NSString stringWithFormat:@"%@wx3api",WXTBaseUrl];   //商城模块
    switch (type) {
        case WXT_UrlFeed_Type_LoadBalance:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Recharge:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Sign:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Login:
            url = @"/app_login.php";
            break;
        case WXT_UrlFeed_Type_Regist:
            url = @"/app_register.php";
            break;
        case WXT_UrlFeed_Type_FetchPwd:
            url = @"";
            break;
        case WXT_UrlFeed_Type_GainNum:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Version:
            url = @"";
            break;
        case WXT_UrlFeed_Type_Call:
            url = @"";
            break;
        case WXT_UrlFeed_Type_HungUp:
            url = @"";
            break;
        case WXT_UrlFeed_Type_ResetPwd:
            url = @"/app_modify_pwd.php";
            break;
        case WXT_UrlFeed_Type_NewMall_TopImg:
            url = @"/get_top_image.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Recommond:
            url = @"/get_commend_goods.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Nav:
            url = @"/get_navigation.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Theme:
            url = @"/get_theme_list.php";
            break;
        case WXT_UrlFeed_Type_NewMall_Surprise:
            url = @"/get_surprise_goods.php";
            break;
        case WXT_UrlFeed_Type_NewMall_CatagaryList:
            url = @"";
            break;
        case WXT_UrlFeed_Type_NewMall_GoodsInfo:
            url = @"/get_single_goods_info.php";
            break;
        case WXT_UrlFeed_Type_NewMall_ImgAndText:
            url = @"";
            break;
        case WXT_UrlFeed_Type_NewMall_ShoppingCart:
            url = @"/get_shopping_cart.php";
            break;
        case WXT_UrlFeed_Type_NewMall_UserAddress:
            url = @"/get_user_address.php";
            break;
        case WXT_UrlFeed_Type_NewMall_MakeOrder:
            url = @"/insert_order.php";
            break;
        case WXT_UrlFeed_Type_New_UserBonus:
            url = @"/get_red_packet.php";
            break;
        case WXT_UrlFeed_Type_New_GainBonus:
            url = @"/get_receive_red_packet.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserBonus:
            url = @"/get_user_red_packet.php";
            break;
        case WXT_UrlFeed_Type_New_OrderList:
            url = @"/get_order_info.php";
            break;
        case WXT_UrlFeed_Type_New_DealOrderList:
            url = @"/update_order_status.php";
            break;
        case WXT_UrlFeed_Type_New_Code:
            url = @"/get_rcode.php";
            break;
        case WXT_UrlFeed_Type_New_ResetNewPwd:
            url = @"/app_reset_pwd.php";
            break;
        case WXT_UrlFeed_Type_New_Refund:
            url = @"/update_order_refund.php";
            break;
        case WXT_UrlFeed_Type_New_RefundInfo:
            url = @"/get_refund_info.php";
            break;
        case WXT_UrlFeed_Type_New_UpdapaOrderID:
            url = @"/get_pay_status.php";
            break;
        case WXT_UrlFeed_Type_New_AboutShop:
            url = @"/get_seller_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Version:
            url = @"/app_version.php";
            break;
        case WXT_UrlFeed_Type_New_Balance:
            url = @"/app_balance.php";
            break;
        case WXT_UrlFeed_Type_New_JPushMessageInfo:
            url = @"/get_message_detail.php";
            break;
        case WXT_UrlFeed_Type_New_Call:
            url = @"/app_cb.php";
            break;
        case WXT_UrlFeed_Type_New_Sign:
            url = @"/app_sign_in.php";
            break;
        case WXT_UrlFeed_Type_New_PersonalInfo:
            url = @"/get_user_info.php";
            break;
        case WXT_UrlFeed_Type_New_Recharge:
            url = @"/app_recharge.php";
            break;
        case WXT_UrlFeed_Type_New_Wechat:
            url = @"/get_prepay_id.php";
            break;
        case WXT_UrlFeed_Type_New_UserCut:
            url = @"/get_divide_list.php";
            break;
        case WXT_UrlFeed_Type_New_RechargeList:
            url = @"/insert_recharge_order.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyGoodsList:
            url = @"/get_all_award.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyShark:
            url = @"/get_lottery_draw_goods.php";
            break;
        case WXT_UrlFeed_Type_New_SharkNumber:
            url = @"/get_award_number.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyMakeOrder:
            url = @"/insert_award_order.php";
            break;
        case WXT_UrlFeed_Type_New_LuckyOrderList:
            url = @"/get_award_order.php";
            break;
        case WXT_UrlFeed_Type_New_LoadJPushMessage:
            url = @"/get_new_message.php";
            break;
        case WXT_UrlFeed_Type_New_CompleteLuckyOrder:
            url = @"/update_award_status.php";
            break;
        case WXT_UrlFeed_Type_New_SharedSucceed:
            url = @"/get_share_award.php";
            break;
        case WXT_UrlFeed_Type_New_UpdateUserHeader:
            url = @"/app_upload_userpic.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserHeader:
            url = @"/get_user_pic.php";
            break;
        case WXT_UrlFeed_Type_New_LoadMyCutInfo:
            url = @"/get_divide_list2.php";
            break;
        case WXT_UrlFeed_Type_New_LoadMyClientPerson:
            url = @"/get_divide_userlist.php";
            break;
        case WXT_UrlFeed_Type_New_LoadMyClientInfo:
            url = @"/get_singleuser_divide.php";
            break;
        case WXT_UrlFeed_Type_New_LoadUserAliAccount:
            url = @"/app_get_withdraw_account.php";
            break;
        case WXT_UrlFeed_Type_New_SubmitUserAliAcount:
            url = @"/app_set_withdraw_account.php";
            break;
        case WXT_UrlFeed_Type_New_ApplyAliMoney:
            url = @"/app_user_withdraw.php";
            break;
        case WXT_UrlFeed_Type_New_LoadAliRecordList:
            url = @"/app_user_withdraw_list.php";
            break;
        case WXT_UrlFeed_Type_New_LoadClassifyData:
            url = @"/get_top_category.php";
            break;
        case WXT_UrlFeed_Type_New_LoadClassifyGoodsList:
            url = @"/get_cat_goods.php";
            break;
        case WXT_UrlFeed_Type_New_SearchGoods:
            url = @"/app_search.php";
            break;
        case WXT_UrlFeed_Type_New_CheckAreaVersion:
            url = @"/get_area_version.php";
            break;
        case WXT_UrlFeed_Type_New_LoadAreaData:
            url = @"/get_all_area.php";
            break;
        case WXT_UrlFeed_Type_NewMall_NewUserAddress:
            url = @"/get_user_address2.php";
            break;
        case WXT_UrlFeed_Type_New_SearchCarriageMoney:
            url = @"/get_order_postage.php";
            break;
        case WXT_UrlFeed_Type_New_NewMakeOrder:
            url = @"/insert_order2.php";
            break;
        default:
            break;
    }
    NSString *compURL = [NSString stringWithFormat:@"%@%@",rootURL,url];
    if(![url isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@%@",newRootUrl,url];
    }
    return compURL;
}

- (NSString*)urlRequestParamFrom:(NSDictionary*)dic{
    NSArray *keys = [dic allKeys];
    if ([keys count] == 0){
        return nil;
    }
    
    NSMutableString *mutString = [NSMutableString string];
    for (NSString *key in keys){
        id value = [dic objectForKey:key];
        if (!value){
            KFLog_Normal(YES, @"无效的参数 key = %@",key);
            continue;
        }
        if ([keys indexOfObject:key] != 0){
            [mutString appendString:@"&"];
        }
        [mutString appendFormat:@"%@=%@",key,value];
    }
    return mutString;
}

@end
