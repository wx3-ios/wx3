//
//  WXContacterEntity.m
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXContacterEntity.h"
#import "AddressBook.h"
#import "PinYinSearchOBJ.h"

typedef enum {
    E_Param_Type_RID = 0,  //RID
    E_Param_Type_Phone,    //电话号码
    E_Param_Type_NickName, //别名
    E_Param_Type_Remark,   //备注名
    E_Param_Type_RecordID, //recordID
    E_Param_Type_WXID,     //我信ID
    E_Param_Type_IconPath, //大头贴的路径
    
    E_Param_Type_ISWX, //是否为我信~
    
    E_Param_Type_Invalid,
}E_Param_Type;

@implementation WXContacterEntity

- (void)dealloc{
    RELEASE_SAFELY(_nickName);
    RELEASE_SAFELY(_rID);
    RELEASE_SAFELY(_iconPath);
    RELEASE_SAFELY(_bindID);
    RELEASE_SAFELY(_remark);
    [super dealloc];
}

+ (WXContacterEntity*)wxContacterWithParamArray:(NSArray*)paramArray{
    NSString *wxID = paramArray[E_Param_Type_WXID];
    if(!wxID || [wxID isEqualToString:@"0"]){
        return nil;
    }
    return [[[WXContacterEntity alloc] initWithParamArray:paramArray] autorelease];
}

+ (WXContacterEntity*)increaseWXContacterWithParamArray:(NSArray *)paramArray{
    NSString *wxID = paramArray[E_Param_Type_WXID];
    NSString *isWX = paramArray[E_Param_Type_IconPath];
    if(!wxID || [wxID isEqualToString:@"0"]){
        return nil;
    }
    if(!isWX || [isWX isEqualToString:@"0"]){
        return nil;
    }
    return [[[WXContacterEntity alloc] initWithParamArray:paramArray] autorelease];
}

- (NSString*)nameShow{
    if(_remark){
        return _remark;
    }
    
    if(_nickName){
        return _nickName;
    }
    
    ContacterEntity *entity = [[AddressBook sharedAddressBook] contacterEntityForNumber:_bindID];
    NSString *name = entity.name;
    if(!name){
        name = _bindID;
    }
    return name;
}

- (UIImage*)iconShow{
    UIImage *icon = nil;
    if(_iconPath){
        icon = [UIImage imageWithContentsOfFile:_iconPath];
    }
    return icon;
}

- (E_ContactRightView)rightViewType{
    return E_ContactRightView_ShowWXIcon;
}

- (id)initWithParamArray:(NSArray*)paramArray{
    if(self = [super init]){
        NSString *wxID = paramArray[E_Param_Type_WXID];
        NSString *rid = paramArray[E_Param_Type_RID];
        NSString *phone = paramArray[E_Param_Type_Phone];
        NSString *nickName = paramArray[E_Param_Type_NickName];
        NSString *remark = paramArray[E_Param_Type_Remark];
        NSString *recordIDStr = paramArray[E_Param_Type_RecordID];
        NSString *iconPath = paramArray[E_Param_Type_IconPath];
        
        [self setWxID:wxID];
        [self setRID:rid];
        [self setBindID:phone];
        if([nickName isEqualToString:@""]){
            nickName = nil;
        }
        [self setNickName:nickName];
        if([remark isEqualToString:@""]){
            remark = nil;
        }
        [self setRemark:remark];
        [self setIconPath:iconPath];
        if(recordIDStr){
            [self setRecordID:[recordIDStr integerValue]];
        }else{
            [self setRecordID:-1];
        }
    }
    return self;
}

- (BOOL)matchingString:(NSString *)string{
    if([_bindID rangeOfString:string].location != NSNotFound){
        return YES;
    }
    
    if(_nickName){
        if([PinYinSearchOBJ isIncludeString:string inString:_nickName]){
            return YES;
        }
    }
    
    ContacterEntity *entity = [[AddressBook sharedAddressBook] contacterEntityForNumber:_bindID];
    NSString *contacterName = entity.name;
    if(contacterName){
        if([PinYinSearchOBJ isIncludeString:string inString:contacterName]){
            return YES;
        }
    }
    
    return NO;
}

@end
