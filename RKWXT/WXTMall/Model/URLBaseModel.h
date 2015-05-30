//
//  URLBaseModel.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseModel.h"
#import "WXTURLFeedOBJ.h"

@interface URLBaseModel : BaseModel
-(void)loadDataType:(WXT_UrlFeed_Type)type httpMethod:(WXT_HttpMethod)httpMethod timeoutIntervcal:(CGFloat)timeoutInterval feed:(NSDictionary*)feed completion:(void(^)(URLFeedData *retData))completion;

@end
