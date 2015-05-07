//
//  CallViewController.m
//  AiCall
//
//  Created by jjyo.kwan on 13-11-26.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//
#import "CallViewController.h"
#import "WXTUITabBarController.h"
#import "CallBackVC.h"
#import "WXKeyPadModel.h"
#import "CallHistoryCell.h"
#import "SimpleContacterCell.h"
#import "SysContacterEntityEx.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WXTCallHistoryCell.h"
#import "CallHistoryEntity.h"
#import "WXTDatabase.h"
#import "CallHistoryEntityExt.h"

#define Size self.view.bounds.size

typedef enum{
    ScrollView_Type_Normal = 0,
    ScrollView_Type_DidScroll,
    ScrollView_Type_StopScroll,
}ScrollView_Type;

@interface CallViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,CallHistoryDelegate>{
    UIView *_keybView;
    //
    UITextField *_textLabel;
    NSString *textString;
    NSString *phoneName;
    //键盘
    NSArray *_numSelArr;
    NSArray *_numNorArr;
    
    ScrollView_Type scroll_type;
    
    //
    UITableView *_tableView;
    BOOL _showContacters;
    WXKeyPadModel *_model;
}

@end

@implementation CallViewController

-(id)init{
    self = [super init];
    if(self){
        _numSelArr = @[@"1S.png",@"2S.png",@"3S.png",@"4S.png",@"5S.png",@"6S.png",@"7S.png",@"8S.png",@"9S.png",@"*S.png",@"0S.png",@"#S.png"];
        _numNorArr = @[@"1N.png",@"2N.png",@"3N.png",@"4N.png",@"5N.png",@"6N.png",@"7N.png",@"8N.png",@"9N.png",@"*N.png",@"0N.png",@"#N.png"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.keyPad_type = E_KeyPad_Show; //键盘
    self.downview_type = DownView_show;
    scroll_type = ScrollView_Type_Normal;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.bounds.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
//    [_tableView setEditing:YES animated:YES];
    [self addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    textString = [[NSString alloc] init];
    phoneName = [[NSString alloc] init];
    _model = [[WXKeyPadModel alloc] init];
    
    [self createKeyboardView];
    [_model searchContacter:@"1"];
}


-(void)addNotification{   //有点问题
    self.keyPad_type = E_KeyPad_Down;
    [self show];
    
    [NOTIFY_CENTER removeObserver:self];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(show) name:ShowKeyBoard object:nil];
    [defaultCenter addObserver:self selector:@selector(callPhoneNumber) name:CallPhone object:nil];
    [defaultCenter addObserver:self selector:@selector(callHistoryChanged) name:D_Notification_Name_CallRecordAdded object:nil];
    [defaultCenter addObserver:self selector:@selector(setEmptyText) name:D_Notification_Name_SystemCallFinished object:nil];
}

-(void)createKeyboardView{
    _keybView = [[UIView alloc] init];
    _keybView.frame = CGRectMake(0, Size.height-InputTextHeight-yGap-50-4*NumberBtnHeight, Size.width, 4*NumberBtnHeight+InputTextHeight);
    [_keybView setBackgroundColor:WXColorWithInteger(0xe6e6e6)];
    [self.view addSubview:_keybView];
    
    _textLabel = [[UITextField alloc] init];
    _textLabel.frame = CGRectMake(0, 0, Size.width, InputTextHeight);
    [_textLabel setBackgroundColor:[UIColor whiteColor]];
    [_textLabel setPlaceholder:@"请输入电话号码"];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setFont:WXTFont(18.0)];
    [_textLabel setEnabled:NO];
    [_textLabel setTextColor:[UIColor grayColor]];
    [_keybView addSubview:_textLabel];
    
    UIImage *eyeImg = [UIImage imageNamed:@"keyboardEye.png"];
    WXTUIButton *eyeBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = CGRectMake(15, (InputTextHeight-eyeImg.size.height-8)/2, eyeImg.size.width+10, eyeImg.size.height+8);
    [eyeBtn setBackgroundColor:[UIColor clearColor]];
    [eyeBtn setBackgroundImage:eyeImg forState:UIControlStateNormal];
    [_keybView addSubview:eyeBtn];
    
    UIImage *img = [UIImage imageNamed:@"delNumber.png"];
    WXTUIButton *delBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(Size.width-img.size.width-20, (InputTextHeight-img.size.height-8)/2, img.size.width+10, img.size.height+8);
    [delBtn setBackgroundColor:[UIColor clearColor]];
    [delBtn setBackgroundImage:img forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_keybView addSubview:delBtn];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBtn:)];
    [longPressGesture setDelegate:self];
    longPressGesture.minimumPressDuration = 0.5;//默认0.5秒
    [delBtn addGestureRecognizer:longPressGesture];
    
    
    CGFloat numBtnWidth = Size.width/3;
    NSInteger line = -1;
    for(int j = 0;j < 4; j++){
        for(int i = 0;i < 3; i++){
            line ++;
            WXUIButton *numBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            numBtn.frame = CGRectMake(i*numBtnWidth, j*NumberBtnHeight+InputTextHeight, numBtnWidth-(i<2?0.5:-2), NumberBtnHeight-(j<3?0.5:0));
            [numBtn setImage:[UIImage imageNamed:_numNorArr[line]] forState:UIControlStateNormal];
            [numBtn setImage:[UIImage imageNamed:_numSelArr[line]] forState:UIControlStateSelected];
            [numBtn setBackgroundImageOfColor:WXColorWithInteger(0xFAFAFA) controlState:UIControlStateNormal];
            [numBtn setBackgroundImageOfColor:WXColorWithInteger(0x2b9be5) controlState:UIControlStateSelected];
            [numBtn setTag:line];
            [numBtn addTarget:self action:@selector(numberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_keybView addSubview:numBtn];
        }
    }
}

-(void)numberBtnClicked:(id)sender{
    WXUIButton *btn = sender;
    NSInteger number = (btn.tag+1==11?0:btn.tag+1);
    if(number <= 9 && number >= 0){
        if(textString.length < 12){
            NSString *str = [NSString stringWithFormat:@"%ld",(long)number];
            textString = [textString stringByAppendingString:str];
            [_textLabel setText:textString];
        }
        [self sound:number];
    }
    
    if(textString.length > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:InputNumber object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownKeyBoard object:nil];
    }
    [self showSearchResult];
}

-(void)sound:(NSInteger)strSound{
    NSString *ch = [NSString stringWithFormat:@"%ld",(long)strSound];
    NSString *string = [NSString stringWithFormat:@"dtmf-%@",ch];
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"aif"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

-(void)delBtnClick{
    NSString *callStrString = _textLabel.text;
    if(callStrString.length > 0){
        NSRange rang = NSMakeRange(0, callStrString.length-1);
        NSString *strRang = [callStrString substringWithRange:rang];
        _textLabel.text = strRang;
        textString = _textLabel.text;
    }
    if(textString.length == 0){
        _downview_type = DownView_Del;
        [[NSNotificationCenter defaultCenter] postNotificationName:DelNumberToEnd object:nil];
        [_model searchContacter:@"1"];
        _showContacters = NO;
        [_tableView reloadData];
    }else{
        [self showSearchResult];
    }
}

-(void)longPressBtn:(id)sender{
    [self setEmptyText];
    self.keyPad_type = E_KeyPad_Show;
    _downview_type = DownView_Del;
}

-(void)showSearchResult{
    [_model searchContacter:textString];
    _showContacters = YES;
    [_tableView reloadData];
}

-(void)show{
    if(self.keyPad_type == E_KeyPad_Show){
        self.keyPad_type = E_KeyPad_Down;
        _downview_type = DownView_Del;
        if(textString.length > 0){
            _downview_type = DownView_show;
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowDownView object:nil];
        }
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-yGap-50, Size.width, 4*NumberBtnHeight);
            if(Size.width==DIphoneSixWidth){ //简单判断一下是苹果6
                _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-yGap-50+IphoneSixYGap, Size.width, 4*NumberBtnHeight);
            }
            if(Size.width==DIphoneSixPWidth){ //简单判断一下是苹果6lus
                _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-yGap-50+IphoneSixPYgap, Size.width, 4*NumberBtnHeight);
            }
        }];
        return;
    }
    if(self.keyPad_type == E_KeyPad_Down){
        scroll_type = ScrollView_Type_StopScroll;
        self.keyPad_type = E_KeyPad_Show;
        if(textString.length > 0){
            _downview_type = DownView_show;
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowDownView object:nil];
        }else{
            _downview_type = DownView_Del;
            [[NSNotificationCenter defaultCenter] postNotificationName:HideDownView object:nil];
        }
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-yGap-50-4*NumberBtnHeight-InputTextHeight+(Size.width>IPHONE_SCREEN_WIDTH?(Size.width==DIphoneSixWidth?IphoneSixYGap:IphoneSixPYgap):0), Size.width, 4*NumberBtnHeight+InputTextHeight);
            if(Size.width==DIphoneSixWidth){ //简单判断一下是苹果6
                _keybView.frame = CGRectMake(0, Size.height-yGap-50-4*NumberBtnHeight-InputTextHeight+IphoneSixYGap, Size.width, 4*NumberBtnHeight+InputTextHeight);
            }
            if(Size.width==DIphoneSixPWidth){ //简单判断一下是苹果6plus
                _keybView.frame = CGRectMake(0, Size.height-yGap-50-4*NumberBtnHeight-InputTextHeight+IphoneSixYGap, Size.width, 4*NumberBtnHeight+InputTextHeight);
            }
        }];
        return;
    }
    if(self.keyPad_type == E_KeyPad_Noraml){
        self.keyPad_type = E_KeyPad_Show;
    }
}

-(void)down{
    if (self.keyPad_type == E_KeyPad_Down) {
        [UIView animateWithDuration:KeyboardDur animations:^{
            _keybView.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-72-50-4*NumberBtnHeight, Size.width, 4*NumberBtnHeight);
        }];
    }
}

-(void)callPhoneNumber{
//    if(_textLabel.text.length < 10 || _textLabel.text.length > 12){
//        [UtilTool showAlertView:@"您所拨打的电话格式不正确"];
//        return;
//    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    if([textString isEqualToString:userObj.user]){
        [UtilTool showAlertView:@"不能拨打登录号码"];
        return;
    }
    if(_callDelegate && [_callDelegate respondsToSelector:@selector(callPhoneWith:andPhoneName:)]){
        [_callDelegate callPhoneWith:textString andPhoneName:[self searchPhoneNameWithUserPhone:textString]];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scroll_type == ScrollView_Type_DidScroll){
        return;
    }
    scroll_type = ScrollView_Type_DidScroll;
    self.keyPad_type = E_KeyPad_Show;
    [self show];
    if(textString.length > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:HideDownView object:nil];
    }
}

//根据手机号匹配用户名，如果未匹配到返回手机号
-(NSString*)searchPhoneNameWithUserPhone:(NSString*)userPhone{
    if(!userPhone){
        return nil;
    }
    for(SysContacterEntityEx *entity in _model.contacterFilter){
        for(NSString *phoneStr in entity.contactEntity.phoneNumbers){
            NSString *newPhoneStr = [UtilTool callPhoneNumberRemovePreWith:phoneStr];
            if([userPhone isEqualToString:newPhoneStr]){
                phoneName = entity.contactEntity.fullName?entity.contactEntity.fullName:phoneStr;
                return phoneName;
            }
        }
    }
    return userPhone;
}

//根据手机号匹配用户名，如果未匹配到返回未知,使用在通话记录
-(NSString*)searchPhoneNameWithUserPhones:(NSString*)userPhone{
    NSString *userName = @"未知";
    if(!userPhone){
        return nil;
    }
    for(SysContacterEntityEx *entity in _model.contacterFilter){
        for(NSString *phoneStr in entity.contactEntity.phoneNumbers){
            NSString *newPhoneStr = [UtilTool callPhoneNumberRemovePreWith:phoneStr];
            NSString *newUserPhoneStr = [UtilTool callPhoneNumberRemovePreWith:userPhone];
            if([newUserPhoneStr isEqualToString:newPhoneStr]){
                phoneName = entity.contactEntity.fullName?entity.contactEntity.fullName:phoneStr;
                return phoneName;
            }
        }
    }
    return userName;
}

#pragma mark tableViewDelegate
- (WXTCallHistoryCell*)callHistoryCellAtRow:(NSInteger)row{
    static NSString *callHistoryCellIdentifier = @"callHistoryCellIdentifier";
    WXTCallHistoryCell *cell = [_tableView dequeueReusableCellWithIdentifier:callHistoryCellIdentifier];
    if(!cell){
        cell = [[WXTCallHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:callHistoryCellIdentifier] ;
    }
    [cell setDelegate:self];
    CallHistoryEntityExt *callHistoryEntity = [_model.callHistoryList objectAtIndex:row];
    NSString *name = [self searchPhoneNameWithUserPhones:callHistoryEntity.callHistoryEntity.phoneNumber];
    [cell setUserName:name];
    [cell setCellInfo:[_model.callHistoryList objectAtIndex:row]];
    [cell load];
    return cell;
}

- (SimpleContacterCell*)contactCellAtRow:(NSInteger)row{
    static NSString *identifier = @"SimpleContacterCell";
    SimpleContacterCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[SimpleContacterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
    }
    //    [cell setBaseDelegate:self];
    [cell setCellInfo:[_model.contacterFilter objectAtIndex:row]];
    [cell load];
    return cell;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = _model.callHistoryList.count;
    if(_showContacters){
        row = _model.contacterFilter.count;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    if(!_showContacters){
        cell = [self callHistoryCellAtRow:indexPath.row];
    }else{
        cell = [self contactCellAtRow:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_showContacters){
        NSInteger row = indexPath.row;
        SysContacterEntityEx *entity = nil;
        if([_model.contacterFilter count] > 0){
            entity = [_model.contacterFilter objectAtIndex:row];
        }
        textString = [UtilTool callPhoneNumberRemovePreWith:entity.phoneMatched];
        [self callPhoneNumber];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return /*UITableViewCellEditingStyleInsert | */UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    [_model deleteCallRecordsAtRow:row];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)reloadData{
    [_tableView reloadData];
}

-(void)callHistoryName:(NSString *)nameStr andPhone:(NSString *)phoneStr{
    if(!phoneStr){
        return;
    }
    textString = [UtilTool callPhoneNumberRemovePreWith:phoneStr];
    [self callPhoneNumber];
}

-(void)setEmptyText{
    [_textLabel setText:@""];
    textString = @"";
    phoneName = @"";
    _showContacters = NO;
    [_model searchContacter:@"1"];
    [_tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:DelNumberToEnd object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NOTIFY_CENTER removeObserver:self];
}

#pragma mark WXKeyPadModelDelegate
-(void)callHistoryChanged{
    [_tableView reloadData];
}

-(void)callRecordHasCleared{
    
}

@end
