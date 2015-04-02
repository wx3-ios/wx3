//
//  WXTFindModel.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    Find_Type_Normal = 0,
    Find_Type_ShowWeb,
    Find_Type_ShowItems,
}Find_Type;

@protocol wxtFindDelegate;
@interface WXTFindModel : NSObject
@property (nonatomic,strong) NSArray *findDataArr;
@property (nonatomic,assign) id<wxtFindDelegate>findDelegate;
@property (nonatomic,assign) Find_Type find_type;
@property (nonatomic,strong) NSString *webUrl;
-(void)loadFindData;
@end

@protocol wxtFindDelegate <NSObject>
-(void)initFinddataSucceed;
-(void)initFinddataFailed:(NSString*)errorMsg;

@end
