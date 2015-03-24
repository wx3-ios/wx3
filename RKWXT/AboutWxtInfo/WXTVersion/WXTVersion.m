//
//  WXTVersion.m
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTVersion.h"
#import "VersionModel.h"
#import "VersionEntity.h"

#define CheckDate @"CheckDate"

@interface WXTVersion()<CheckVersionDelegate,UIAlertViewDelegate>{
    VersionModel *_model;
    VersionEntity *_versionEntity;
}
@end

@implementation WXTVersion

-(id)init{
    self = [super init];
    if(self){
        _model = [[VersionModel alloc] init];
        [_model setDelegate:self];
        self.checkStatus = CheckUpdata_Status_Normal;
    }
    return self;
}

+(WXTVersion *)sharedVersion{
    static dispatch_once_t onceToken;
    static WXTVersion *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[WXTVersion alloc] init];
    });
    return sharedInstance;
}

-(NSString*)currentVersion{
    NSString *curVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return curVersion;
}

-(NSString*)showCurrentVersion{
    NSString *curVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return [[self class] currentVersionShow:curVersion];
}

+ (NSString*)currentVersionShow:(NSString*)oldVersion{
    NSArray *subVersionArray = [oldVersion componentsSeparatedByString:@"."];
    if([subVersionArray count] > 3){
        NSMutableString *mutVersion = [NSMutableString string];
        NSInteger max = 3;
        for(NSInteger index = 0; index < max; index++){
            [mutVersion appendString:[subVersionArray objectAtIndex:index]];
            if(index != max-1){
                [mutVersion appendString:@"."];
            }
        }
        oldVersion = mutVersion;
    }
    return oldVersion;
}

-(void)checkVersion{
    if(_checkType == Version_CheckType_System){
        if([[self class] checkDate]){
            return;
        }
    }
    [_model checkVersion:[self currentVersion]];
}

#pragma mark versionDelegate
-(void)checkVersionSucceed{
    self.checkStatus = CheckUpdata_Status_Ending;
    if([_model.updateArr count] > 0){
        _versionEntity = [_model.updateArr objectAtIndex:0];
        NSString *message = _versionEntity.updateMsg;
        if(_versionEntity.updateType == WXT_Version_Advance){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"马上升级", nil];
            [alert show];
        }
        if(_versionEntity.updateType == WXT_Version_Force){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上升级", nil];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(_versionEntity.updateType == WXT_Version_Advance){
        if(buttonIndex == 1){
            //itms-services://?action=download-manifest&url=https://gz.67call.com/Ios/2.plist
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_versionEntity.appUrl]];
        }
    }
    if(_versionEntity.updateType == WXT_Version_Force){
        if(buttonIndex == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_versionEntity.appUrl]];
        }
    }
}

-(void)checkVersionFailed:(NSString *)errorMsg{
    self.checkStatus = CheckUpdata_Status_Ending;
    NSString *message = errorMsg;
    if(!message){
        message = @"检查最新版本失败";
    }
    if(_checkType == Version_CheckType_User){
        [UtilTool showAlertView:message];
    }
}

+(BOOL)checkDate{
    NSDate *sendDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [dateformatter stringFromDate:sendDate];
    
    if([locationString isEqualToString:[[self class] lastCheckDate]]){
        return YES;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:locationString forKey:CheckDate];
    
    return NO;
}

+(NSString*)lastCheckDate{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:CheckDate];
}

@end
