//
//  AppDelegate.m
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AppDelegate.h"
#import "WXUITabBarVC.h"
#import "IQKeyboardManager.h"
#import "DDFileLogger.h"
#import "LoginVC.h"
#import "WXTVersion.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import "ContactUitl.h"
#import "APService.h"
#import "LoginModel.h"
#import "WXTUITabbarVC.h"
#import "CallViewController.h"
#import "NewWXTLiDB.h"
#import "AliPayControl.h"
#import "JPushMessageModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ScreenActivityVC.h"
#import "WXTGuideVC.h"

#import "WXWeiXinOBJ.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "UserInfoVC.h"
#import "ShareSucceedModel.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate (){
    CTCallCenter *_callCenter;
    ScreenActivityVC *activityVC;
    
    BOOL hasDeal;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    
    [[AddressBook sharedAddressBook] loadContact];
    [ContactUitl shareInstance];
    [self initUI];
    //监听电话
    [self listenSystemCall];
    // 集成极光推送功能
    [self initJPushApi];
    [APService setupWithOption:launchOptions];
    
    //自动登录通知
    [self addNotification];
    
    //向微信注册
    [[WXWeiXinOBJ sharedWeiXinOBJ] registerApp];
    //    [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"wx"];
    //向qq注册
    id result = [[TencentOAuth alloc] initWithAppId:@"1104707907" andDelegate:nil];
    if(result){}
    
    return YES;
}

-(void)addNotification{
    [NOTIFY_CENTER addObserver:self selector:@selector(loginSucceed:) name:KNotification_LoginSucceed object:nil];
    [NOTIFY_CENTER addObserver:self selector:@selector(loginFailed:) name:KNotification_LoginFailed object:nil];
}

-(void)removeNotification{
    [NOTIFY_CENTER removeObserver:self];
}

-(void)initUI{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //    activityVC = [[ScreenActivityVC alloc] init];
    //    self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:activityVC];
    //    [self.window setRootViewController:self.navigationController];
    //    [self.window makeKeyAndVisible];
    //    return;
    
    BOOL userInfo = [self checkUserInfo];
    if(userInfo){
        WXTUITabbarVC *tabbarVC = [[WXTUITabbarVC alloc] init];
        self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:tabbarVC];
        [self.window setRootViewController:self.navigationController];
        [self.window makeKeyAndVisible];
        
        [[NewWXTLiDB sharedWXLibDB] loadData];
        [self checkVersion];
        //自动登录
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
        //        LoginModel *_loginModel = [[LoginModel alloc] init];
        //        [_loginModel loginWithUser:userDefault.user andPwd:userDefault.pwd];
        
        [userDefault SetUserLoginFirst:YES];
        [APService setTags:[NSSet setWithObject:[NSString stringWithFormat:@"%@",userDefault.user]] alias:nil callbackSelector:nil object:nil];
    }else{
        WXUIViewController *vc = nil;
        if(kMerchantID == 100000 || kMerchantID == 10145){
            vc = [[WXTGuideVC alloc] init];
            self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:vc];
        }else{
            vc = [[LoginVC alloc] init];
            self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:vc];
        }
        
        [vc.navigationController setNavigationBarHidden:YES];
        [self.window setRootViewController:self.navigationController];
        [self.window makeKeyAndVisible];
    }
}

-(void)loginSucceed:(NSNotification*)notification{
    [[NewWXTLiDB sharedWXLibDB] loadData];
    [self removeNotification];
}

-(void)loginFailed:(NSNotification*)notification{
    [self removeNotification];
    BOOL userInfo = [self checkUserInfo];
    if(userInfo){
        LoginVC *loginVC = [[LoginVC alloc] init];
        WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:navigationController animated:YES completion:^{
        }];
    }
}

-(BOOL)checkUserInfo{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    if(!userDefault.user || !userDefault.pwd || !userDefault.wxtID){
        return NO;
    }
    if(!userDefault.userFirstLogin){
        [userDefault removeAllUserInfo];
        return NO;
    }
    return YES;
}

-(void)listenSystemCall{
    //监听手机通话状态,私有API
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall *call){
        if ([call.callState isEqualToString:CTCallStateIncoming]){
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:D_Notification_Name_SystemCallIncomming object:nil userInfo:nil];
        }else if ([call.callState isEqualToString:CTCallStateDisconnected]){
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:D_Notification_Name_SystemCallFinished object:nil userInfo:nil];
        }
    };
}

-(void)checkVersion{
    WXTVersion *version = [WXTVersion sharedVersion];
    [version setCheckType:Version_CheckType_System];
    [version checkVersion];
}

#pragma mark 极光推送功能
-(void)initJPushApi{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [self addObserver];
}

-(void)addObserver{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification {
    DDLogDebug(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    DDLogDebug(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    DDLogDebug(@"已注册RegistrationID:%@",[[notification userInfo] valueForKey:@"RegistrationID"]);
}

- (void)networkDidLogin:(NSNotification *)notification {
    DDLogDebug(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {  //应用内消息,由锁屏进入应用内
    NSDictionary *userInfo = [notification userInfo];
    //    [APService handleRemoteNotification:userInfo];
    [[JPushMessageModel shareJPushModel] initJPushWithCloseDic:userInfo];
}

- (void)serviceError:(NSNotification *)notification {
    DDLogDebug(@"error:%@", [[notification userInfo] valueForKey:@"error"]);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {   //锁屏状态APNS,字段和应用内不同
    // Required
    [APService handleRemoteNotification:userInfo];
    [[JPushMessageModel shareJPushModel] initJPushWithCloseDic:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo  //点击锁屏消息打开应用收到的消息或者在应用内收到的消息
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    hasDeal = YES;
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [[JPushMessageModel shareJPushModel] initJPushWithDic:userInfo];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in Jpush registration. Error: %@", err);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    CallViewController *callVC = [[CallViewController alloc] init];
    [callVC setEmptyText];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    hasDeal = NO;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];  //设置图标0
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if(!hasDeal){
        [[JPushMessageModel shareJPushModel] loadJPushMessageFromService];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RKWXT" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RKWXT.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //支付宝
    //    [[AliPayControl sharedAliPayOBJ] handleAliPayURL:url];
    //微支付
    [WXApi handleOpenURL:url delegate:self];
    //微信
    [[WXWeiXinOBJ sharedWeiXinOBJ] handleOpenURL:url];
    //qq
    [TencentOAuth HandleOpenURL:url];
    
    UserInfoVC *infoVC = [[UserInfoVC alloc] init];
    [QQApiInterface handleOpenURL:url delegate:infoVC];
    return YES;
}

//微信分享回调
-(void)onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        NSInteger error = resp.errCode;
        if(error != 0){
            NSString *msgError = resp.errStr;
            if(msgError){
                [UtilTool showAlertView:nil message:msgError delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        }else{
            [[ShareSucceedModel sharedSucceed] sharedSucceed];
            [UtilTool showAlertView:nil message:@"微信分享成功" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
    }];
    return YES;
}

@end
