//
//  LogRegColorOBJ.m
//  Woxin2.0
//
//  Created by Elty on 12/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXColorConfig.h"

@implementation WXColorConfig

+ (UIColor*)logAndRegColorWithType:(E_LogRegColorType)type{
	NSInteger regLogColorIndex = [CustomMadeOBJ sharedCustomMadeOBJS].regAndLoginColorEnum;
	NSInteger iColor = logRegColorList[regLogColorIndex][type];
	if (iColor < 0){
		return [UIColor clearColor];
	}
	
	return WXColorWithInteger(iColor);
}

+ (UIColor*)otherColorWithType:(E_App_Other_Color)type{
	NSInteger otherColorEnum = [CustomMadeOBJ sharedCustomMadeOBJS].otherColorEnum;
	NSInteger iColor = otherColor[otherColorEnum][type];
	if (iColor < 0){
		return [UIColor clearColor];
	}
	
	return WXColorWithInteger(iColor);
}

@end
