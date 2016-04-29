//
//  WXTFindModel.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    FindData_Type_None = 0,
    FindData_Type_Load,
    FindData_Type_Updata,
}FindData_Type;

@protocol wxtFindModelDelegate;
@interface WXTFindModel : NSObject
@property (nonatomic,strong) NSArray *findDataArr;
@property (nonatomic,assign) id<wxtFindModelDelegate>findDelegate;

-(void)loadFindData:(FindData_Type)type;
-(void)upLoadUserClickFindData:(NSInteger)discover_id;
@end

@protocol wxtFindModelDelegate <NSObject>
-(void)initFinddataSucceed;
-(void)initFinddataFailed:(NSString*)errorMsg;
@end
