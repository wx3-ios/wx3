//
//  UserHeaderImgModel.h
//  RKWXT
//
//  Created by SHB on 15/7/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHeaderImgModel : NSObject

+(UserHeaderImgModel*)shareUserHeaderImgModel;
-(BOOL)uploadUserHeaderImgWith:(NSData*)imgData;
-(NSString*)userIconPath;

@end
