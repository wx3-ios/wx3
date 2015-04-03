//
//  TelNOOBJ.m
//  Woxin2.0
//
//  Created by le ting on 7/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "TelNOOBJ.h"
#import "ZoneCodeOBJ.h"

#define kPhoneNumberCount (11)


@interface TelNOOBJ ()

@end

@implementation TelNOOBJ

+ (TelNOOBJ*)sharedTelNOOBJ{
    static dispatch_once_t onceToken;
    static TelNOOBJ *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TelNOOBJ alloc] init];
    });
    return sharedInstance;
}

- (NSString*)currentContryCode{
    return @"+86";
}

//去掉IP号码
- (NSString*)removeIPPreFromPhoneNumber:(NSString*)phone{
    NSInteger ipPreCount = sizeof(s_ipPre)/sizeof(const char*);
    NSInteger len = [phone length];
    NSString *newPhone = phone;
    if(len > kPhoneNumberCount){
        for(NSInteger i = 0; i < ipPreCount; i++){
            const char *aIPPre = s_ipPre[i];
            NSString *ipPreStr = [NSString stringWithFormat:@"%s",aIPPre];
            if([newPhone hasPrefix:ipPreStr]){
                NSInteger ipPreLen = [ipPreStr length];
                newPhone = [newPhone substringFromIndex:ipPreLen];
                break;
            }
        }
    }
    return newPhone;
}

- (NSString*)nakedPhone:(NSString*)phone{
    //00开头转化为+
    if([phone hasPrefix:@"00"]){
        phone = [phone substringFromIndex:2];
        phone = [NSString stringWithFormat:@"+%@",phone];
    }
    
    NSMutableString *nakePhone = [NSMutableString string];
    NSInteger len = [phone length];
    NSInteger index = 0;
    if(len > 0){
        //首字母
        const char head = (const char)[phone characterAtIndex:0];
        if(head == '+'){
            index ++;
            [nakePhone appendFormat:@"%c",head];
        }
        
        while (index < len) {
            const char character = (const char)[phone characterAtIndex:index];
            if(character >= '0' && character <= '9'){
                [nakePhone appendFormat:@"%c",character];
            }
            index ++;
        }
    }
    NSString *newPhone = [self removeIPPreFromPhoneNumber:nakePhone];
    if(newPhone && [newPhone length] > 0){
        return newPhone;
    }
    return nil;
}

-(NSString*)telNumberFromOrigin:(NSString*)phone{
    phone = [self removeIPPreFromPhoneNumber:phone];
    phone = [self nakedPhone:phone];
    //如果没有+开头~ 则加上国家码
    if(![phone hasPrefix:@"+"]){
        phone = [NSString stringWithFormat:@"%@%@",[self currentContryCode],phone];
    }
    return phone;
}

- (NSString*)addCountryCode:(NSString*)countryCode toTelNumber:(NSString*)telNumber{
    if([telNumber length] == 0){
        return nil;
    }
    
    if([countryCode length] == 0){
        return telNumber;
    }
    
    telNumber = [self nakedPhone:telNumber];
    if(![telNumber hasPrefix:@"+"]){
        telNumber = [NSString stringWithFormat:@"%@%@",countryCode,telNumber];
    }
    return telNumber;
}

- (BOOL)checkPhoneValid:(NSString*)phone{
	NSString *nakedPhone = [self nakedPhone:phone];
	NSString *phoneWithOutCountryCode = nakedPhone;
	NSString *countryCode = [self currentContryCode];
	//带国家码的~
	if ([nakedPhone hasPrefix:@"+"]){
		//国家码不对~
		if (![nakedPhone hasPrefix:countryCode]){
			return NO;
		}
		phoneWithOutCountryCode = [nakedPhone substringFromIndex:countryCode.length];
	}
	//去掉国家码后号码为空~
	if (phoneWithOutCountryCode.length == 0){
		return NO;
	}
	
	//前面是1的是手机号码~
	if ([phoneWithOutCountryCode hasPrefix:@"1"]){
		if ([phoneWithOutCountryCode length] != kPhoneNumberCount){
			return NO;
		}
		return YES;
	}
	
	//前面是0的则是座机号码
	if ([phoneWithOutCountryCode hasPrefix:@"0"]){
		WXError *error = [[ZoneCodeOBJ sharedZoneCodeOBJ] checkValidForPhone:phoneWithOutCountryCode];
		if (error && error.errorCode == E_ZoneCodeMathCode_Complete){
			return YES;
		}
		return NO;
	}else{
		//前面不是0的则是非法号码
		return NO;
	}
}
@end
