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
#import "WXTUITabBarController.h"
#import "WXTVersion.h"
#import "RootViewController.h"
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

@interface AppDelegate (){
    CTCallCenter *_callCenter;
    ScreenActivityVC *activityVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    Enabling keyboard manager
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    // Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
#if DEBUG
    setenv("XcodeColors", "YES", 1);//加载颜色插件
    NSString *logsDirectory = [DOC_PATH stringByAppendingPathComponent:@"logs"];
    DDLogFileManagerDefault *fileManager = [[DDLogFileManagerDefault alloc]initWithLogsDirectory:logsDirectory];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd HH:MM:ss"];
    DDLogFileFormatterDefault *logFormatter = [[DDLogFileFormatterDefault alloc]initWithDateFormatter:formatter];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc]initWithLogFileManager:fileManager];
    fileLogger.maximumFileSize = kDDDefaultLogMaxFileSize * 4;
    fileLogger.rollingFrequency = kDDDefaultLogRollingFrequency; // 1 day rolling
    [fileLogger setLogFormatter:logFormatter];
    [DDLog addLogger:fileLogger];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];// 允许颜色
#endif
    DDLogError(@"%@", DOC_PATH);
    [[AddressBook sharedAddressBook] loadContact];
    [ContactUitl shareInstance];
	[self initUI];
    [self checkVersion];
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

//#pragma mark qqShared
//-(BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [TencentOAuth HandleOpenURL:url];
//}

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
        //自动登录
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
//        LoginModel *_loginModel = [[LoginModel alloc] init];
//        [_loginModel loginWithUser:userDefault.user andPwd:userDefault.pwd];
        
        [APService setTags:[NSSet setWithObject:[NSString stringWithFormat:@"%@",userDefault.user]] alias:nil callbackSelector:nil object:nil];
    }else{
        WXTGuideVC *vc = [[WXTGuideVC alloc] init];
        self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:vc];
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
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];  //设置图标0
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self saveContext];
}

#pragma mark 崩溃日志
void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========程序异常崩溃，请配合发送异常报告，谢谢合作========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    
    NSMutableString *mailUrl = [NSMutableString string];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"1256752005@qq.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"1667906749@qq.com", nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:[NSString stringWithFormat:@"&subject=%@",kMerchantName]];
    //添加邮件内容
    [mailUrl appendString:[NSString stringWithFormat:@"&body=<b></b>%@",content]];
    
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
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
    [[AliPayControl sharedAliPayOBJ] handleAliPayURL:url];
    //微支付
    [WXApi handleOpenURL:url delegate:self];
    //微信
    [[WXWeiXinOBJ sharedWeiXinOBJ] handleOpenURL:url];
    //qq
    [TencentOAuth HandleOpenURL:url];
    return YES;
}

- (void)dealloc {
    [self unObserveAllNotifications];
}
@end
