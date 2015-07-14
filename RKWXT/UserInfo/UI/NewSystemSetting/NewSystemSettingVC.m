//
//  NewSystemSettingVC.m
//  RKWXT
//
//  Created by SHB on 15/6/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewSystemSettingVC.h"
#import "WXTResetPwdVC.h"
#import "T_SettingSwitchCell.h"
#import "LoginVC.h"

#define KeyPadTone @"KeyPadTone"   //值为0默认开启,1为设置开启,2为设置关闭

enum{
    //    T_Setting_Call = 0,
//    T_Setting_Contact = 0,
    T_Setting_Password = 0,
    T_Setting_KeyPadTone,
    T_Setting_RemoveData,
    
    T_Setting_Invalid,
}T_Setting_Type;

@interface NewSystemSettingVC()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SettingKeyPadToneDelegate>{
    WXUITableView *_tableView;
    WXUIButton *quitBtn;
    BOOL quit;
}
@end

@implementation NewSystemSettingVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"设置"];
    quit = NO;
    
    CGSize size = self.bounds.size;
    _tableView = [[WXUITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableForFootView]];
}

-(WXUIView*)tableForFootView{
    WXUIView *footView = [[WXUIView alloc] init];
    
    CGFloat yOffset = 40;
    CGFloat btnHeight = 44;
    quitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(10, yOffset, IPHONE_SCREEN_WIDTH-2*10, btnHeight);
    [quitBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [quitBtn setBorderRadian:4.0 width:0.1 color:WXColorWithInteger(0xdd2726)];
    [quitBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [quitBtn setTitle:@"退出登陆" forState:UIControlStateSelected];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:quitBtn];
    
    yOffset += btnHeight;
    CGRect rect = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, yOffset);
    [footView setFrame:rect];
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_Setting_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(WXUITableViewCell*)tableViewForRemoveDataCell{
    static NSString *identifier = @"removeDataCell";
    T_SettingSwitchCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[T_SettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSInteger value = [self keyPadToneValue];
    if(value == 0 || value == 1){
        [cell setSwitchIsOn:YES];
    }
    [cell setDelegate:self];
    [cell.textLabel setText:@"拨打按键音"];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *string = [[self class] stringWithCellAtSection:indexPath.section];
    [cell.textLabel setText:string];
    if(indexPath.section != T_Setting_RemoveData){
        [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    }
    if(indexPath.section == T_Setting_KeyPadTone){
        cell = (WXUITableViewCell*)[self tableViewForRemoveDataCell];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == T_Setting_Password){
        WXTResetPwdVC *changeVC = [[WXTResetPwdVC alloc] init];
        [self.wxNavigationController pushViewController:changeVC];
    }
    if(section == T_Setting_RemoveData){
        [self showRemoveDataAlertView];
    }
}

+(NSString*)stringWithCellAtSection:(NSInteger)section{
    NSString *string = nil;
    switch (section) {
            //        case T_Setting_Call:
            //            string = @"拨打设置";
            //            break;
//        case T_Setting_Contact:
//            string = @"通讯录备份";
//            break;
        case T_Setting_Password:
            string = @"修改密码";
            break;
        case T_Setting_RemoveData:
            string = @"清除数据缓存";
            break;
        default:
            break;
    }
    return string;
}

-(void)showRemoveDataAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定清除缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(quit){
        quit = NO;
        NSInteger number = buttonIndex;
        if(number == 1){
            //清除用户信息
            WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
            [userDefault removeAllUserInfo];
            
            LoginVC *loginVC = [[LoginVC alloc] init];
            WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:loginVC];
            [self.wxNavigationController presentViewController:navigationController animated:YES completion:^{
                [self.wxNavigationController popToRootViewControllerAnimated:YES Completion:^{
                }];
            }];
        }
    }else{
        if(buttonIndex == 1){
            [self removeData];
        }
    }
}

#pragma mark T_Setting_RemoveData
-(void)keyPadToneSetting:(WXUISwitch *)s{
    NSInteger value1 = 0;
    NSInteger value = [self keyPadToneValue];
    if(value == 0 || value == 1){
        value1 = 2;
    }
    if(value == 2){
        value1 = 1;
    }
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    [userDefault setInteger:value1 forKey:KeyPadTone];
}

-(NSInteger)keyPadToneValue{
    NSInteger value = 0;
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    value = [userDefault integerValueForKey:KeyPadTone];
    return value;
}

-(void)removeData{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock tip:@"缓存清理中"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [UtilTool documentPath];
    path = [path stringByAppendingPathComponent:@"urlDataCache"];
    if ([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    [self performSelector:@selector(checkFile) withObject:nil afterDelay:1.0];
}

-(void)checkFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [UtilTool documentPath];
    path = [path stringByAppendingPathComponent:@"urlDataCache"];
    if(![fileManager fileExistsAtPath:path]){
        [UtilTool showAlertView:@"清理完毕"];
    }
    [self unShowWaitView];
}

#pragma mark quit
-(void)quit{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出我信?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    quit = YES;
}


@end
