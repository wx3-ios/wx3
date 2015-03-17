//
//  GuessYouLikeData.h
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@protocol GuessYouLikeDataDelegate;
@interface GuessYouLikeData : BaseModel
@property (nonatomic,assign)id<GuessYouLikeDataDelegate>delegate;
@property (nonatomic,readonly)NSArray *guessGoods;

- (E_LoadDataReturnValue)loadGuessYouLikeData;
@end

@protocol GuessYouLikeDataDelegate <NSObject>
- (void)guessYouLikeDataedSucceed;
- (void)guessYouLikeDataLoadedFailed;
@end
