//
//  DataSigner.h
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum DataSignAlgorithm {
	DataSignAlgorithmRSA,
	DataSignAlgorithmMD5,
} DataSignAlgorithm;

@protocol DataSigner

- (NSString *)algorithmName;
- (NSString *)signString:(NSString *)string;

@end

id<DataSigner> CreateRSADataSigner(NSString *privateKey);

