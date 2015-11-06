//
//  AllAreaDataModel.h
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CheckAreaVersion @"CheckAreaVersion"

@interface AllAreaDataModel : NSObject

+(AllAreaDataModel*)shareAllAreaData;
-(void)checkAllAreaVersion;

@end
