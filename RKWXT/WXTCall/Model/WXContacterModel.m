//
//  WXContacterModel.m
//  Woxin2.0
//
//  Created by le ting on 7/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXContacterModel.h"
#import "WXContactOptEntity.h"
#import "pinyin.h"

@interface WXContacterModel(){
    NSMutableArray *_contactOPTList;
    NSMutableDictionary *_sysContacterDic;
    NSMutableArray *_keys;
    NSMutableArray *_filterArray;
}
@end

@implementation WXContacterModel
@synthesize contactOptArray = _contactOPTList;
@synthesize sysContacterDic = _sysContacterDic;
@synthesize filterArray = _filterArray;

- (void)dealloc{
    _delegate = nil;
}

- (id)init{
    if(self = [super init]){
        _contactOPTList = [[NSMutableArray alloc] init];
        _sysContacterDic = [[NSMutableDictionary alloc] init];
        _keys = [[NSMutableArray alloc] init];
        _filterArray = [[NSMutableArray alloc] init];
        [self setContactOpts];
        [self initSystemContacters];
        [self loadSystemContacters];
    }
    return self;
}

- (void)setContactOpts{
    [_contactOPTList removeAllObjects];
    NSInteger count = sizeof(pOptInfo)/sizeof(S_OptContactInfo);
    for(int i = 0; i  < count; i++){
        S_OptContactInfo optInfo = pOptInfo[i];
        WXContactOptEntity *entity = [WXContactOptEntity optEntityWithName:optInfo.name icon:[UIImage imageNamed:optInfo.iconStr] numberRight:0];
        [_contactOPTList addObject:entity];
    }
}

- (void)initSystemContacters{
    for(char ch = 'A'; ch <= 'Z'; ch++){
        NSMutableArray *array = [NSMutableArray array];
        [_sysContacterDic setObject:array forKey:[NSString stringWithFormat:@"%c",ch]];
    }
    [_sysContacterDic setObject:[NSMutableArray array] forKey:@"#"];
}

- (void)emptySystemContacters{
    NSArray *allkeys = [_sysContacterDic allKeys];
    for(NSString *key in allkeys){
        NSMutableArray *array = [_sysContacterDic objectForKey:key];
        [array removeAllObjects];
    }
}

- (void)loadSystemContacters{
    [_keys removeAllObjects];
    [self emptySystemContacters];
    
    [_keys addObject:kFirstKey];
    NSArray *sysContacters = [AddressBook sharedAddressBook].contactList;
    for(ContacterEntity *sysContacter in sysContacters){
        char ch = '#';
        NSString *name = sysContacter.fullName;
        if(name && name.length > 0){
            char aCh = pinyinFirstLetter([name characterAtIndex:0]);
            if((aCh >='a' && aCh <='z') || (aCh >= 'A' && aCh <= 'Z') ){
                ch = toupper(aCh);
            }
        }
        NSString *key = [NSString stringWithFormat:@"%c",ch];
        NSMutableArray *array = [_sysContacterDic objectForKey:key];
        [array addObject:sysContacter];
        if([_keys indexOfObject:key] == NSNotFound){
            [_keys addObject:key];
        }
    }
}

- (NSArray*)allKeys{
    _keys = (NSMutableArray*)[_keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return _keys;
}

- (NSIndexPath*)indexPathFor:(ContacterEntity*)entity{
    NSInteger index = [_contactOPTList indexOfObject:entity];
    if(index!= NSNotFound){
        return [NSIndexPath indexPathForRow:index inSection:0];
    }
    NSInteger count = [_keys count];
    if(count > 1){
        for(NSInteger i = 1; i < count; index++){
            NSString *key = [_keys objectAtIndex:i];
            NSArray *contacters = [_sysContacterDic objectForKey:key];
            index = [contacters indexOfObject:entity];
            if(index!= NSNotFound){
                return [NSIndexPath indexPathForRow:index inSection:i];
            }
        }
    }
    return nil;
}

- (void)matchSearchStringList:(NSString*)string{
    __block NSInteger number = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSArray *sysContacterList = [AddressBook sharedAddressBook].contactList;
        for(ContacterEntity *entity in sysContacterList){
            if([entity matchingString:string]){
                number++;
                [_filterArray addObject:entity];
                if(number >= 30){
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SearchContactResult object:nil];
        });
    });
}

- (void)removeMatchingContact{
    [_filterArray removeAllObjects];
}
@end
