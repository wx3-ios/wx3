//
//  SearchUserAliAccountModel.h
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchUserAliAccountModelDelegate;

@interface SearchUserAliAccountModel : NSObject
@property (nonatomic,strong) NSArray *userAliAcountArr;
@property (nonatomic,assign) id<SearchUserAliAccountModelDelegate>delegate;

-(void)searchUserAliPayAccount;

@end

@protocol SearchUserAliAccountModelDelegate <NSObject>
-(void)searchUserAliPayAccountSucceed;
-(void)searchUserAliPayAccountFailed:(NSString*)errorMsg;

@end
