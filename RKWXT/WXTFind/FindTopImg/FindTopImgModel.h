//
//  FindTopImgModel.h
//  RKWXT
//
//  Created by SHB on 16/4/12.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol FindTopImgModelDelegate;

@interface FindTopImgModel : T_HPSubBaseModel
@property (nonatomic,weak) id<FindTopImgModelDelegate>delegate;
@property (nonatomic,strong) NSArray *imgArr;

-(void)loadFindTopImgData;
@end

@protocol FindTopImgModelDelegate <NSObject>
-(void)findTopImgLoadedSucceed;
-(void)findTopImgLoadedFailed:(NSString*)error;

@end
