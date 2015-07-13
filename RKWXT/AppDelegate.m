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

@interface AppDelegate (){
    CTCallCenter *_callCenter;
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
    
    
    BOOL userInfo = [self checkUserInfo];
    if(userInfo){
        WXTUITabbarVC *tabbarVC = [[WXTUITabbarVC alloc] init];
        self.navigationController = [[WXUINavigationController alloc] initWithRootViewController:tabbarVC];
        [self.window setRootViewController:self.navigationController];
        [self.window makeKeyAndVisible];
        
        //自动登录
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
        LoginModel *_loginModel = [[LoginModel alloc] init];
        [_loginModel loginWithUser:userDefault.user andPwd:userDefault.pwd];
        
        [APService setTags:[NSSet setWithObject:[NSString stringWithFormat:@"%@",userDefault.user]] alias:nil callbackSelector:nil object:nil];
    }else{
        LoginVC *vc = [[LoginVC alloc] init];
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

- (void)networkDidReceiveMessage:(NSNotification *)notification {   //锁屏状态APNS
    NSDictionary *userInfo = [notification userInfo];
    [APService handleRemoteNotification:userInfo];
    [[JPushMessageModel shareJPushModel] initJPushWithDic:userInfo];
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
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    [[JPushMessageModel shareJPushModel] initJPushWithDic:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application    //应用内消息
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

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    CallViewController *callVC = [[CallViewController alloc] init];
    [callVC setEmptyText];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];  //设置图标0
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
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
    // The directory the application uses to store the Core Data store file. This code uses a directory named "WoXin.RKWXT" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RKWXT" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
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
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
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
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
    return YES;
}

- (void)dealloc {
    [self unObserveAllNotifications];
}
@end
