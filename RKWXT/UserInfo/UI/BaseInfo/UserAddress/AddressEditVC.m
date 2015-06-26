//
//  AddressEditVC.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AddressEditVC.h"
#import "WXTUITextField.h"
#import "UserAddressModel.h"

@interface AddressEditVC (){
    WXTUITextField *_nameTextfield;
    WXTUITextField *_phoneTextfield;
    WXTUITextField *_addressTextfield;
}

@end

@implementation AddressEditVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"地址编辑"];
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    
    [self createBaseView];
    [self createCompleteBtn];
    [self addNotification];
}

-(void)addNotification{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(insertAddressSucceed) name:K_Notification_UserAddress_InsertDataSucceed object:nil];
    [notification addObserver:self selector:@selector(insertAddressFailed:) name:K_Notification_UserAddress_InsertDataFailed object:nil];
    [notification addObserver:self selector:@selector(modifyAddressSucceed) name:K_Notification_UserAddress_ModifyDateSucceed object:nil];
    [notification addObserver:self selector:@selector(modifyAddressFailed:) name:K_Notification_UserAddress_ModifyDateFailed object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createBaseView{
    CGFloat xOffset = 15;
    CGFloat yOffset = 15;
    CGFloat textFieldHeight = 41;
    CGSize size = self.bounds.size;
    _nameTextfield = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, size.width-2*xOffset, textFieldHeight)];
    [_nameTextfield setReturnKeyType:UIReturnKeyDone];
    [_nameTextfield addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_nameTextfield setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_nameTextfield setTextColor:[UIColor grayColor]];
    [_nameTextfield setTintColor:[UIColor blackColor]];
//    [_nameTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [_nameTextfield setBackgroundColor:[UIColor whiteColor]];
    [_nameTextfield setPlaceHolder:@"请输入收货人姓名" color:[UIColor grayColor]];
    [_nameTextfield setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_nameTextfield];
    
    
    yOffset += textFieldHeight+10;
    _phoneTextfield = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, size.width-2*xOffset, textFieldHeight)];
    [_phoneTextfield setReturnKeyType:UIReturnKeyDone];
    [_phoneTextfield addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_phoneTextfield setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_phoneTextfield setTextColor:[UIColor grayColor]];
    [_phoneTextfield setTintColor:[UIColor blackColor]];
//    [_phoneTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [_phoneTextfield setBackgroundColor:[UIColor whiteColor]];
    [_phoneTextfield setTextAlignment:NSTextAlignmentCenter];
    [_phoneTextfield setPlaceHolder:@"请输入收货人手机号" color:[UIColor grayColor]];
    [self addSubview:_phoneTextfield];
    
    yOffset += textFieldHeight+10;
    _addressTextfield = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, size.width-2*xOffset, textFieldHeight)];
    [_addressTextfield setReturnKeyType:UIReturnKeyDone];
    [_addressTextfield addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_addressTextfield setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
    [_addressTextfield setTextColor:[UIColor grayColor]];
//    [_addressTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    [_addressTextfield setBackgroundColor:[UIColor whiteColor]];
    [_addressTextfield setTintColor:[UIColor blackColor]];
    [_addressTextfield setTextAlignment:NSTextAlignmentCenter];
    [_addressTextfield setPlaceHolder:@"请输入收货地址" color:[UIColor grayColor]];
    [self addSubview:_addressTextfield];
    
    if(_entity){
        [_nameTextfield setText:_entity.userName];
        [_phoneTextfield setText:_entity.userPhone];
        [_addressTextfield setText:_entity.address];
    }
}

-(void)createCompleteBtn{
    CGFloat yOffset = 170;
    CGFloat xOffset = 10;
    CGFloat btnHeight = 44;
    WXTUIButton *completeBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width-2*xOffset, btnHeight);
    [completeBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [completeBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(complieteAddressEdit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:completeBtn];
}

-(void)complieteAddressEdit{
    if(_nameTextfield.text.length != 0 && _phoneTextfield.text.length != 0 && _addressTextfield.text.length != 0){
        if(_address_type == Address_Type_Insert){
            [[UserAddressModel shareUserAddress] insertUserAddressWithName:_nameTextfield.text withAdd:_addressTextfield.text withPhone:_phoneTextfield.text];
        }else{
            [[UserAddressModel shareUserAddress] modifyUserAddressWithName:_nameTextfield.text withAdd:_addressTextfield.text withPhone:_phoneTextfield.text withID:_entity.address_id];
        }
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }else{
        [UtilTool showAlertView:@"信息不完整"];
    }
}

#pragma mark inserDate
-(void)insertAddressSucceed{
    [self unShowWaitView];
    [self resignAllFirstResponder];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)insertAddressFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"添加收货信息失败,请重试";
    }
    [UtilTool showAlertView:message];
}

#pragma mark modify
-(void)modifyAddressSucceed{
    [self unShowWaitView];
    [self resignAllFirstResponder];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)modifyAddressFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"修改收货信息失败,请重试";
    }
    [UtilTool showAlertView:message];
}

-(void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

-(void)resignAllFirstResponder{
    [_nameTextfield resignFirstResponder];
    [_phoneTextfield resignFirstResponder];
    [_addressTextfield resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignAllFirstResponder];
    [self removeNotification];
}

@end
