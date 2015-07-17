//
//  UserAgent.m
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-8.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "UserAgent.h"
#import <EGODatabase/EGODatabase.h>
//#import "NetRequest.h"
#import "ContactUitl.h"
#import "NSDictionary+Plist.h"
//#import "Gossip.h"

#define PATH_CONFIG [DOC_PATH stringByAppendingPathComponent:@"config.plist"]
#define PATH_BALANCE [DOC_PATH stringByAppendingPathComponent:@"blance.plist"]
#define PaySwitch @"PaySwitch"

@implementation UserAgent

SYNTHESIZE_SINGLETON_FOR_CLASS(UserAgent);

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [NSDictionary dictionaryWithContentsOfPlistFile:PATH_CONFIG];
        self.balance = [NSDictionary dictionaryWithContentsOfPlistFile:PATH_BALANCE];
        if (![USER_DEFAULT stringForKey:kUserAgentLocation]) {
            [USER_DEFAULT setValue:@"0755" forKey:kUserAgentLocation];
        }
    }
    return self;
}


- (EGODatabase *)database
{
    if (!_database) {
        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"gjt.db"];
        _database = [EGODatabase databaseWithPath:path];
    }
    return _database;
}

/*
- (BOOL)hasLogin
{
    NSString *uid = [USER_DEFAULT stringForKey:kUserAgentUid];
    NSString *pwd = [USER_DEFAULT stringForKey:kUserAgentPwd];
    
    BOOL login = uid && pwd;
    if (login) {
        [NET_REQUEST setUid:uid];
        [NET_REQUEST setPwd:pwd];
    }
    return login;
}


- (void)initData
{
    if (![self hasLogin]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //获取配置
        int etag = [_config[@"etag"] integerValue];
        NSDictionary *attr = @{@"etag":@(etag)};
        NSDictionary *json = [NET_REQUEST httpAction:@"app_config.php" attribute:attr];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (RESULT_SUCCESS(json)) {
                [USER_DEFAULT setValue:[json objectForKey:@"thirdpay"] forKey:@"PaySwitch"];
                self.config = json;
                if (![_config writeToPlistFile:PATH_CONFIG]) {
                    DDLogError(@"wirte config file faild...PATH:[%@]", PATH_CONFIG);
                };
            }
        });
    });
}

- (void)updateBalance:(void(^)(NSDictionary *balance))complete;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *json = [NET_REQUEST httpAction:@"app_balance.php"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (RESULT_SUCCESS(json)) {
                self.balance = json;
                if (![json writeToPlistFile:PATH_BALANCE]) {
                    DDLogError(@"wirte balance file faild.....");
                }
            }
            if (complete) {
                complete(json);
            }
        });
        
    });
}*/

-(void)updateBalance:(void (^)(NSDictionary *))complete{
}

#pragma mark - sip
/*
- (GSAccount *)sipAccount
{
    if (!_sipAccount) {
        //sip 配置信息
        NSDictionary *sipDict = [[USER_AGENT config] objectForKey:@"sip"];
        
        
        NSString *user = [USER_DEFAULT stringForKey:kUserAgentUid];
        NSString *pwd = [USER_DEFAULT stringForKey:kUserAgentPwd];
        
        NSString *domain = [NSString stringWithFormat:@"%@:%@", sipDict[@"proxy"], sipDict[@"port"]];
        
        GSAccountConfiguration *account = [GSAccountConfiguration defaultConfiguration];
        account.address = [NSString stringWithFormat:@"<sip:%@@%@>", user, domain];
        account.domain = [NSString stringWithFormat:@"sip:%@", domain];
        account.username = user;
        account.password = pwd;
        
        GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
        configuration.account = account;
        configuration.logLevel = 3;
        configuration.consoleLogLevel = 3;
        
        GSUserAgent *agent = [GSUserAgent sharedAgent];
        if (agent.status == GSUserAgentStateUninitialized) {
            [agent configure:configuration];
            [agent start];
        }
        //设置使用编码
        NSArray *codecs = [agent arrayOfAvailableCodecs];
        for (GSCodecInfo *codec in codecs) {
            if (![codec.codecId hasPrefix:@"G729"]) {
                DDLogDebug(@"Disabling: %@", codec.codecId);
                [codec disable];
            } else {
                DDLogDebug(@"Maximizing: %@", codec.codecId);
                [codec setPriority:254];
            }
        }
        _sipAccount = agent.account;
    }
    return _sipAccount;
}
*/
@end
