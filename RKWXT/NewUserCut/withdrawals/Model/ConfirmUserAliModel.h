//
//  ConfirmUserAliModel.h
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    UserAli_Confirm = 1,
    UserAli_Change,
}UserAli_Submit;

@protocol ConfirmUserAliModelDelegate;

@interface ConfirmUserAliModel : NSObject
@property (nonatomic,assign) id<ConfirmUserAliModelDelegate>delegate;

-(void)confirmUserAliAcountWith:(NSString*)userAliAcount with:(NSString*)userName with:(UserAli_Submit)aliType with:(NSInteger)rcode with:(NSString*)userPhone;

@end

@protocol ConfirmUserAliModelDelegate <NSObject>
-(void)confirmUserAliAcountSucceed;
-(void)confirmUserAliAcountFailed:(NSString*)errorMsg;

@end
