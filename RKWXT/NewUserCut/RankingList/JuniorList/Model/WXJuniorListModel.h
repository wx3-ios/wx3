//
//  WXJuniorListModel.h
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXJuniorListModelDelegate;

@interface WXJuniorListModel : NSObject
@property (nonatomic,assign) id <WXJuniorListModelDelegate>delegate;
@property (nonatomic,strong) NSArray *juniorArr;

-(void)loadWXJuniorListData;
@end

@protocol WXJuniorListModelDelegate <NSObject>
-(void)loadWXJuniorListDataSucceed;
-(void)loadWXJuniorListDataFailed:(NSString*)errorMsg;

@end
