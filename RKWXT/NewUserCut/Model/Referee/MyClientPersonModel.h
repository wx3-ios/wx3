//
//  MyClientPersonModel.h
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

typedef enum{
    MyClient_Grade_First = 1,
    MyClient_Grade_Second,
    MyClient_Grade_Third,
    
    MyClient_Grade_Invalid,
}MyClient_Grade;

@protocol MyClientPersonModelDelegate;

@interface MyClientPersonModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *clientList;
@property (nonatomic,assign) id<MyClientPersonModelDelegate>delegate;

-(void)loadMyClientPersonList:(MyClient_Grade)client_grade;

@end

@protocol MyClientPersonModelDelegate <NSObject>
-(void)loadMyClientPersonListSucceed;
-(void)loadMyClientPersonListFailed:(NSString*)errorMsg;

@end
