//
//  TopADVEntity.h
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	E_TopADVType_Good = 1,//商品~
	E_TopADVType_Category,//分类列表~
	E_TopADVType_Message,//网页消息
	E_TopADVType_AboutUS,//关于商家~
}E_TopADVType;

@interface TopADVEntity : NSObject
@property (nonatomic,assign)E_TopADVType advType;
@property (nonatomic,assign)NSInteger msgID;
@property (nonatomic,retain)NSString *msgURL;
@property (nonatomic,assign)NSInteger sortID;
@property (nonatomic,assign)NSString *imageURL;
@property (nonatomic,retain)NSString *title;

+ (TopADVEntity*)topADVEntityWithDictionary:(NSDictionary*)dic;
@end
