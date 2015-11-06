//
//  NewAddressEditVC.m
//  RKWXT
//
//  Created by SHB on 15/11/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "NewAddressEditVC.h"
#import "NewAddressAreaCell.h"
#import "NewAddressInfoCell.h"
#import "NewAddressTextfieldCell.h"
#import "CityAddress.h"
#import "UserAddressModel.h"
#import <UIKit/UIKit.h>

#define Size self.bounds.size
#define pickerViewHeight (240)

enum{
    AddressEdit_Row_Name = 0,
    AddressEdit_Row_Phone,
    AddressEdit_Row_Area,
    AddressEdit_Row_Info,
    
    AddressEdit_Row_Invalid,
};

@interface NewAddressEditVC()<UITableViewDataSource,UITableViewDelegate,NewAddressInfoCellDelegate,NewTextFieldCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    UITableView *_tableView;
    UIPickerView *picker;
    CityAddress *cityAddressModel;
    
    UIView *shellView;
    BOOL showPicker;
}
@property (nonatomic,strong) NSString *selectProvince;
@property (nonatomic,strong) NSString *selectCity;
@property (nonatomic,strong) NSString *selectDistrict;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *areaStr;
@property (nonatomic,strong) NSString *infoStr;
@end

@implementation NewAddressEditVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"地址编辑"];
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    [self addNotification];
    
    if(_entity){
        self.userName = _entity.userName;
        self.userPhone = _entity.userPhone;
        self.areaStr = _entity.address;
    }
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self createSelectAreaPickerView];
    [self addSubview:[self staticFootView]];
    cityAddressModel = [[CityAddress alloc] init];
    [cityAddressModel loadUserAddressData];
}

-(void)addNotification{
//    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
//    [notification addObserver:self selector:@selector(insertAddressSucceed) name:K_Notification_UserAddress_InsertDataSucceed object:nil];
//    [notification addObserver:self selector:@selector(insertAddressFailed:) name:K_Notification_UserAddress_InsertDataFailed object:nil];
//    [notification addObserver:self selector:@selector(modifyAddressSucceed) name:K_Notification_UserAddress_ModifyDateSucceed object:nil];
//    [notification addObserver:self selector:@selector(modifyAddressFailed:) name:K_Notification_UserAddress_ModifyDateFailed object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createSelectAreaPickerView{
    shellView = [[WXUIView alloc] init];
    shellView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [shellView setHidden:YES];
    [shellView setUserInteractionEnabled:YES];
    [shellView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:shellView];
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, IPHONE_SCREEN_HEIGHT, Size.width, pickerViewHeight)];
    picker.dataSource = self;
    picker.delegate = self;
    [picker setBackgroundColor:[UIColor whiteColor]];
    picker.showsSelectionIndicator = YES;
    [picker selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:picker];
}

-(UIView*)staticFootView{
    CGFloat btnHeight = 43;
    UIView *footView = [[UIView alloc] init];
    [footView setBackgroundColor:[UIColor whiteColor]];
    footView.frame = CGRectMake(0, Size.height-btnHeight, Size.width, btnHeight);
    
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 0, Size.width, btnHeight);
    [submitBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:WXFont(18.0)];
    [submitBtn addTarget:self action:@selector(submitUserInfoData) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submitBtn];
    return footView;
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < AddressEdit_Row_Info){
        return 44.0;
    }
    return NewAddressInfoCellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return AddressEdit_Row_Invalid;
}

-(WXUITableViewCell *)tableViewForAddressNameCell{
    static NSString *identifier = @"nameCell";
    NewAddressTextfieldCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewAddressTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAlertText:@"收货人姓名"];
    [cell setTag:AddressEdit_Row_Name];
    [cell setCellInfo:self.userName];
    [cell load];
    return cell;
}

-(WXUITableViewCell *)tableViewForAddressPhoneCell{
    static NSString *identifier = @"phoneCell";
    NewAddressTextfieldCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewAddressTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAlertText:@"收货人电话"];
    [cell setTag:AddressEdit_Row_Phone];
    [cell setCellInfo:self.userPhone];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAddressAreaCell{
    static NSString *identifier = @"areaCell";
    NewAddressAreaCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewAddressAreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:self.areaStr];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAddressInfoCell{
    static NSString *identifier = @"infoCell";
    NewAddressInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewAddressInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case AddressEdit_Row_Name:
            cell = [self tableViewForAddressNameCell];
            break;
        case AddressEdit_Row_Phone:
            cell = [self tableViewForAddressPhoneCell];
            break;
        case AddressEdit_Row_Area:
            cell = [self tableViewForAddressAreaCell];
            break;
        case AddressEdit_Row_Info:
            cell = [self tableViewForAddressInfoCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == AddressEdit_Row_Area){
        [self newAddressAreaBtnClicked];
    }
}

#pragma mark picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == PROVINCE_COMPONENT){
        return [cityAddressModel.province count];
    }else if (component == CITY_COMPONENT){
        return [cityAddressModel.city count];
    }else{
        return [cityAddressModel.district count];
    }
}

#pragma mark Picker Delegate Methods
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == PROVINCE_COMPONENT){
        cityAddressModel.selectedProvince = [cityAddressModel.province objectAtIndex:row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:[cityAddressModel.areaDic objectForKey:[NSString stringWithFormat:@"%d",row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[tmp objectForKey:cityAddressModel.selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator:^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i = 0; i < [sortedArray count]; i++){
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey:index] allKeys];
            [array addObject:[temp objectAtIndex:0]];
        }
        
        cityAddressModel.city = [[NSArray alloc] initWithArray:array];
        
        NSDictionary *cityDic = [dic objectForKey:[sortedArray objectAtIndex:0]];
        cityAddressModel.district = [[NSArray alloc] initWithArray:[cityDic objectForKey:[cityAddressModel.city objectAtIndex:0]]];
        self.selectProvince = cityAddressModel.selectedProvince;
        self.selectCity = [cityAddressModel.city objectAtIndex:0];
        self.selectDistrict = [cityAddressModel.district objectAtIndex:0];
        
        [picker selectRow:0 inComponent:CITY_COMPONENT animated:YES];
        [picker reloadComponent:CITY_COMPONENT];
        [picker selectRow:0 inComponent:DISTRICT_COMPONENT animated:YES];
        [picker reloadComponent:DISTRICT_COMPONENT];
    }else if (component == CITY_COMPONENT){
        NSString *provinceIndex = [NSString stringWithFormat:@"%d",[cityAddressModel.province indexOfObject:cityAddressModel.selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:[cityAddressModel.areaDic objectForKey:provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[tmp objectForKey:cityAddressModel.selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:[dic objectForKey:[sortedArray objectAtIndex:row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        cityAddressModel.district = [[NSArray alloc] initWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
        self.selectCity = [cityAddressModel.city objectAtIndex:row];
        self.selectDistrict = [cityAddressModel.district objectAtIndex:0];
        [picker selectRow:0 inComponent:DISTRICT_COMPONENT animated:YES];
        [picker reloadComponent:DISTRICT_COMPONENT];
    }else{
        self.selectDistrict = [cityAddressModel.district objectAtIndex:row];
    }

    if ([cityAddressModel.selectedProvince isEqualToString:self.selectCity] && [self.selectCity isEqualToString:self.selectDistrict]) {
        self.selectCity = @"";
        self.selectDistrict = @"";
    }
    else if ([self.selectCity isEqualToString:self.selectDistrict]) {
        self.selectDistrict = @"";
    }
    
    self.areaStr = [NSString stringWithFormat:@"%@%@%@",self.selectProvince,self.selectCity,self.selectDistrict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:AddressEdit_Row_Area inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component == PROVINCE_COMPONENT){
        return 80;
    }else if (component == CITY_COMPONENT){
        return 100;
    }else{
        return 115;
    }
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = nil;
    CGFloat labelHeight = 30;
    if(component == PROVINCE_COMPONENT){
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, labelHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [cityAddressModel.province objectAtIndex:row];
        myView.font = WXFont(14.0);
        [myView setBackgroundColor:[UIColor clearColor]];
    }else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, labelHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [cityAddressModel.city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, labelHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [cityAddressModel.district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

#pragma mark btn
-(void)newAddressAreaBtnClicked{
    showPicker = !showPicker;
    if(showPicker){
        [self showPickerView];
    }else{
        [self unShowPickerView];
    }
}

#pragma mark  cell
-(void)textFiledValueDidChanged:(NSString *)text with:(NSInteger)tag{
    showPicker = NO;
    [self unShowPickerView];
    if(tag == AddressEdit_Row_Name){
        self.userName = text;
    }
    if(tag == AddressEdit_Row_Phone){
        self.userPhone = text;
    }
}

-(void)textViewValueDidChanged:(NSString*)text{
    showPicker = NO;
    [self unShowPickerView];
    self.infoStr = text;
}

#pragma mark submit
-(void)submitUserInfoData{
    if(self.userName.length != 0 && self.userPhone.length != 0 && self.areaStr.length != 0){
        if(![self checkUserPhoneWithString:self.userPhone]){
            return;
        }
        if(_address_type == NewAddress_Type_Insert){
//            [[UserAddressModel shareUserAddress] insertUserAddressWithName:self.userName withAdd:self.areaStr withPhone:self.userPhone];
        }else{
//            [[UserAddressModel shareUserAddress] modifyUserAddressWithName:self.userName withAdd:self.areaStr withPhone:self.userPhone withID:_entity.addressID];
        }
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }else{
        [UtilTool showAlertView:@"信息不完整"];
    }
}

-(BOOL)checkUserPhoneWithString:(NSString*)phone{
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:phone];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"您添加的号码格式不正确"];
        return NO;
    }
    return YES;
}

#pragma mark picker
-(void)showPickerView{
    [shellView setHidden:NO];
    [shellView setAlpha:0.1];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = picker.frame;
        rect.origin.y = IPHONE_SCREEN_HEIGHT-pickerViewHeight;
        rect.size.height = pickerViewHeight;
        [picker setFrame:rect];
    }];
}

-(void)unShowPickerView{
    [shellView setHidden:YES];
    [shellView setAlpha:1.0];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = picker.frame;
        rect.origin.y = IPHONE_SCREEN_HEIGHT;
        rect.size.height = 0;
        [picker setFrame:rect];
    }];
}

#pragma mark inserDate
-(void)insertAddressSucceed{
    [self unShowWaitView];
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

#pragma mark touch
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    showPicker = NO;
    [self unShowPickerView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    showPicker = NO;
    [self unShowPickerView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

@end
