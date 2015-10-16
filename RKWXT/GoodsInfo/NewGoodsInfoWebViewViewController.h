//
//  NewGoodsInfoWebViewViewController.h
//  RKWXT
//
//  Created by SHB on 15/10/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "NLSubViewController.h"
#import "WXTURLFeedOBJ.h"

@interface NewGoodsInfoWebViewViewController : NLSubViewController
-(id)initWithFeedType:(WXT_UrlFeed_Type)urlFeedType paramDictionary:(NSDictionary*)paramDictionary;

@end
