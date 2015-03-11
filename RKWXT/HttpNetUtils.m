//
//  HttpNetUtils.m
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HttpNetUtils.h"
#import "AFHTTPRequestOperationManager.h"
#import "Constants.h"

@implementation HttpNetUtils

//http://gz.67call.com/agent/api.php?cmd=login&agent_id=2&phone_number=18603052335&password=123456
+(void)test{
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"cmd":@"login",@"phone_number":@"18603052335",@"password":@"123456",@"agent_id":kAgentId};
    [operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject:%@",responseObject);
    }failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"Response:%@\nError:%@\nError userInfo:%@\n",[operation responseObject],error,[error userInfo]);
    }];
}

+(void)loginHttpActionWith:(NSString *)userName andPasswd:(NSString *)passwd andCallback:(CallBack)callBack{
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
	NSDictionary * parameters = @{@"cmd":@"login",@"phone_number":userName,@"password":passwd,@"agent_id":kAgentId};
	[operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        callBack(responseObject);
//        [USER_DEFAULT setObject:responseObject[@"token"] forKey:@"token"];
        NSLog(@"%sresponseObject:%@\ntoken:%@",__func__,responseObject,responseObject[@"token"]);
	}failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%sresponse:%@\nError:%@\nError userInfo:%@\n",__func__,[operation responseObject],error,[error userInfo]);
	}];
}

+(void)registerHttpActionWith:(NSString*)phoneNo andCallback:(CallBack)callBack{
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"cmd":@"register",@"agent_id":kAgentId,@"phone_number":phoneNo};
    [operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        callBack(responseObject);
        NSLog(@"%sresponseObject:%@",__func__,responseObject);
    }failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%sresponse:%@\nError:%@\nError userInfo:%@\n",__func__,[operation responseObject],error,[error userInfo]);
    }];
}

+(void)forgetPasswdWith:(NSString *)phoneNo andCallback:(CallBack)callBack{
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"cmd":@"forget_ password",@"agent_id":kAgentId,@"phone_number":phoneNo};
    [operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        callBack(responseObject);
        NSLog(@"%sresponseObject:%@",__func__,responseObject);
    }failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%sresponse:%@\nError:%@\nError userInfo:%@\n",__func__,[operation responseObject],error,[error userInfo]);
    }];
}

+(void)callPhoneActionWith:(NSString *)userId andCalled:(NSString *)called andCallback:(CallBack)callBack{
//    NSString * token = [USER_DEFAULT objectForKey:@"token"];
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"cmd":@"call",@"user_id":userId,@"called":called,@"agent_id":kAgentId,@"token":kTestToken};
    [operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        callBack(responseObject);
        NSLog(@"%sresponseObject:%@\nmsg:%@",__func__,responseObject,responseObject[@"msg"]);
    }failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%sresponse:%@\nError:%@\nError userInfo:%@\n",__func__,[operation responseObject],error,[error userInfo]);
    }];
}

+(void)officialPayWith:(NSString *)userId andPhoneNo:(NSString*)phoneNo andCardSN:(NSString*)cardSN andCardPS:(NSString*)cardPS andCallback:(CallBack)callBack{
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"cmd":@"pay",@"agent_id":kAgentId,@"user_id":userId,@"token":kTestToken,@"phone_number":phoneNo,@"card_sn":cardSN,@"card_ps":cardPS};
    [operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        callBack(responseObject);
        NSLog(@"%sresponseObject:%@",__func__,responseObject);
    }failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%sresponse:%@\nError:%@\nError userInfo:%@\n",__func__,[operation responseObject],error,[error userInfo]);
    }];
}

+(void)getBalanceWith:(NSString *)userId andCallback:(CallBack)callBack{
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"cmd":@"get_balance",@"user_id":userId,@"agent_id":kAgentId,@"token":kTestToken};
    [operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        callBack(responseObject);
        NSLog(@"%sresponseObject:%@",__func__,responseObject);
    }failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%sresponse:%@\nError:%@\nError userInfo:%@\n",__func__,[operation responseObject],error,[error userInfo]);
    }];
}

+(void)dailyAttendanceWith:(NSString *)userId andCallback:(CallBack)callBack{
    AFHTTPRequestOperationManager * operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary * parameters = @{@"cmd":@"daily_attendance",@"user_id":userId,@"agent_id":kAgentId,@"token":kTestToken};
    [operationManager POST:@"http://api.67call.com/agent/api.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        callBack(responseObject);
        NSLog(@"%sresponseObject:%@\nmsg:%@",__func__,responseObject,responseObject[@"msg"]);
    }failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%sresponse:%@\nError:%@\nError userInfo:%@\n",__func__,[operation responseObject],error,[error userInfo]);
    }];
}

@end
