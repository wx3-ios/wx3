//
//  WXKeyPadVC.m
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXKeyPadVC.h"
#import "KeyPadView.h"
#import "WXCallUITabBarVC.h"
#import "CallRecord.h"
#import "CallHistoryCell.h"
#import "SimpleContacterCell.h"
//#import "CallOBJ.h"
#import "WXKeyPadModel.h"
#import "TelNOOBJ.h"
#import "WXContacterEntity.h"
#import "ContacterEntity.h"
#import "StrangerEntity.h"
#import "WXTUITabBarController.h"

enum{
	E_ALERTVIEW_CLEAR_ALL_RECORDS_ID = 10001
};

typedef enum{
	E_LEFT_BAR_BUTTON_BACK = 0,
	E_LEFT_BAR_BUTTON_CLEAR,
}E_Left_BarButton_Mode;

typedef enum{
	E_RIGHT_BAR_BUTTON_TOEDIT = 0,
	E_RIGHT_BAR_BUTTON_FINISHEDIT,
	
	E_RIGHT_BAR_BUTTON_HIDE,//隐藏
}E_Right_BarButton_Mode;

#define kTitle @"拨号"
@interface WXKeyPadVC ()<KeyPadViewDelegate,UITableViewDataSource,UITableViewDelegate,WXUITableViewCellDelegate,WXKeyPadModelDelegate,UITextViewDelegate>{
    KeyPadView *_keyPad;
    WXUITableView *_tableView;
    WXKeyPadModel *_model;
    
    BOOL _showContacters;
	BOOL _inEdit;
    WXUIButton *_rightButton;
	WXUIButton *_leftButton;
    
    WXUITextView *_textView;
    
    UISegmentedControl *_segmentControl;
}
@property (nonatomic,retain)NSString *keyPadNumber;
@end

@implementation WXKeyPadVC
- (void)dealloc{
//    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
//    [self setCSTTitle:kTitle];
//    [self setBackNavigationBarItem];
    
    CGFloat xOffset = 30;
    CGFloat yOffset = 25;
    _textView = [[WXUITextView alloc] init];
    _textView.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, 25);
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:16.0]];
    [_textView setHidden:YES];
    [_textView setTextColor:[UIColor blackColor]];
    [_textView setTextAlignment:NSTextAlignmentCenter];
    [_textView setEditable:NO];
    [_textView setScrollEnabled:NO];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_textView];
    
    CGSize size = self.bounds.size;
    _tableView = [[WXUITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:WXColorWithInteger(0xcbcbcb)];
    [self addSubview:_tableView];
    _keyPad = [[KeyPadView alloc] initWithFrame:CGRectMake(0, size.height, size.width, kKeyPadHeight)];
    [_keyPad setDelegate:self];
    [self addSubview:_keyPad autoresizingMask:UIViewAutoresizingFlexibleTopMargin];
	
	UIFont *font = WXFont(14.0);
//	UIColor *normalColor = WXColorWithInteger(0xffffff);
	UIColor *highlightColor = WXColorWithInteger(0xff0000);
	_rightButton = [WXUIButton buttonWithType:UIButtonTypeCustom] ;
	[_rightButton.titleLabel setFont:font];
	[_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_rightButton setTitleColor:highlightColor forState:UIControlStateHighlighted];
	[_rightButton setFrame:CGRectMake(0, 0, 60, NAVIGATION_BAR_HEGITH)];
	[_rightButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self setRightNavigationItem:_rightButton];
	
	_leftButton = [WXUIButton buttonWithType:UIButtonTypeCustom] ;
	[_leftButton.titleLabel setFont:font];
    [_leftButton setHidden:YES];
	[_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_leftButton setTitleColor:highlightColor forState:UIControlStateHighlighted];
	[_leftButton setFrame:CGRectMake(0, 0, kDefaultNavigationBarButtonSize.width, kDefaultNavigationBarButtonSize.height)];
	[_leftButton addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self setLeftNavigationItem:_leftButton];
	[self rightBarButtonToMode:E_RIGHT_BAR_BUTTON_TOEDIT];
	[self leftBarButtonToMode:E_LEFT_BAR_BUTTON_BACK];
	
    _model = [[WXKeyPadModel alloc] init];
    [_model setDelegate:self];
    
    [self upKeyBoardButtonClicked];
    [self loadSegmentControl];
}

-(void)loadSegmentControl{
    CGFloat segWidth = 180;
    CGFloat segHeight = 30;
    NSArray *nameArr = @[@"通话",@"通讯录"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:nameArr];
    _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
    if(isIOS6){
        _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
    }
    [_segmentControl setSelectedSegmentIndex:0];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
#endif
    [_segmentControl setBorderRadian:1.0 width:0.2 color:[UIColor grayColor]];
    [_segmentControl setBackgroundColor:[UIColor whiteColor]];
    [_segmentControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentControl];
}

- (void)showContacters:(BOOL)show{
	_showContacters = show;
	E_Left_BarButton_Mode leftMode = E_LEFT_BAR_BUTTON_BACK;
	E_Right_BarButton_Mode rightMode = E_RIGHT_BAR_BUTTON_TOEDIT;
	if(_showContacters){
		rightMode = E_RIGHT_BAR_BUTTON_HIDE;
	}
	[self leftBarButtonToMode:leftMode];
	[self rightBarButtonToMode:rightMode];
}

- (void)leftBarButtonToMode:(E_Left_BarButton_Mode)mode{
	UIImage *img = nil;
	NSString *title = nil;
	switch (mode) {
	  case E_LEFT_BAR_BUTTON_BACK:
        {
            [_leftButton setHidden:YES];
        }
		img = [UIImage imageNamed:@"back.png"];
		break;
	case E_LEFT_BAR_BUTTON_CLEAR:
        {
            [_leftButton setHidden:NO];
        }
		title = @"清除";
		break;
	}
	[_leftButton setImage:img forState:UIControlStateNormal];
	[_leftButton setTitle:title forState:UIControlStateNormal];
}

- (void)clearAllRecords{
	[self rightBarButtonToMode:E_RIGHT_BAR_BUTTON_TOEDIT];
	[self leftBarButtonToMode:E_LEFT_BAR_BUTTON_BACK];
	[_model clearAllRecords];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[self toEdit:NO animated:NO];
}

- (void)callRecordHasCleared{
	[self finishEdit];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1){
		[self clearAllRecords];
	}
}

- (void)alertClearAllRecords{
	if ([_model.callHistoryList count] == 0){
		[UtilTool showAlertView:@"当前通话记录列表为空"];
	}else{
		[UtilTool showAlertView:nil message:@"是否确定要清除所有通话记录" delegate:self tag:E_ALERTVIEW_CLEAR_ALL_RECORDS_ID cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
	}
}

- (void)leftBarButtonClicked{
	if(_inEdit){
		[self alertClearAllRecords];
	}else{
		[self back];
	}
}

- (void)toEdit:(BOOL)edit animated:(BOOL)animated{
	[_tableView setEditing:edit animated:animated];
	_inEdit = edit;
}

- (void)rightBarButtonToMode:(E_Right_BarButton_Mode)mode{
	NSString *title = nil;
	BOOL hide = NO;
	switch (mode) {
		case E_RIGHT_BAR_BUTTON_TOEDIT:
			title = @"编辑";
			break;
		case E_RIGHT_BAR_BUTTON_FINISHEDIT:
			title = @"完成";
			break;
		case E_RIGHT_BAR_BUTTON_HIDE:
			hide = YES;
			break;
	}
	[_rightButton setTitle:title forState:UIControlStateNormal];
	[_rightButton setHidden:hide];
}

- (void)toEdit{
	[self rightBarButtonToMode:E_RIGHT_BAR_BUTTON_FINISHEDIT];
	[self leftBarButtonToMode:E_LEFT_BAR_BUTTON_CLEAR];
	[self toEdit:YES animated:YES];
}

- (void)finishEdit{
	[self rightBarButtonToMode:E_RIGHT_BAR_BUTTON_TOEDIT];
	[self leftBarButtonToMode:E_LEFT_BAR_BUTTON_BACK];
	[self toEdit:NO animated:YES];
}

- (void)rightBarButtonClicked{
	if(_inEdit){
		[self finishEdit];
	}else{
		[self toEdit];
	}
}

- (void)showTableView{
    [_model searchContacter:_keyPadNumber];
    [_tableView reloadData];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = _model.callHistoryList.count;
    if(_showContacters){
        row = _model.contacterFilter.count;
    }
    return row;
}

- (CallHistoryCell*)callHistoryCellAtRow:(NSInteger)row{
    static NSString *callHistoryCellIdentifier = @"callHistoryCellIdentifier";
    CallHistoryCell *cell = [_tableView dequeueReusableCellWithIdentifier:callHistoryCellIdentifier];
    if(!cell){
        cell = [[CallHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:callHistoryCellIdentifier] ;
    }
    [cell setBaseDelegate:self];
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
    [cell setBaseDelegate:self];
    [cell setCellInfo:[_model.contacterFilter objectAtIndex:row]];
    [cell load];
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCallHistoryCellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self keyBoardDown];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *phoneNumber = nil;
    if(_showContacters){
        phoneNumber = [_model contactPhoneAtRow:indexPath.row];
    }else{
        phoneNumber = [_model callHistoryPhoneAtRow:indexPath.row];
    }
    if(phoneNumber){
//        [self makeCall:phoneNumber];
    }else{
        KFLog_Normal(YES, @"无效的号码");
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger row = indexPath.row;
	[_model deleteCallRecordsAtRow:row];
	[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	BOOL ret = NO;
	if(!_showContacters){
		ret = YES;
	}
	return ret;
}

//- (void)makeCall:(NSString*)phoneNumber{
//	WXError *error = [[CallOBJ sharedCallOBJ] makeUIBackCall:phoneNumber];
//	if (error.errorCode != 0){
//		NSString *errorMsg = error.errorMessage;
//		if (!errorMsg){
//			errorMsg = @"呼叫失败,请重试";
//		}
//		[UtilTool showAlertView:errorMsg];
//	}
//}

#pragma mark WXUITableViewCellDelegate
- (void)clickButtonToDetail:(id)sender{
    WXUITableViewCell *cell = sender;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(!indexPath){
        KFLog_Normal(YES, @"无效联系人~");
        return;
    }
    ContactBaseEntity *entity = nil;
    if(_showContacters){
        entity = [_model searchContactEntityAtRow:indexPath.row];
    }else{
        entity = [_model callhistoryContactEntityAtRow:indexPath.row];
    }
//    [self toContacterDetail:entity];
}

//- (void)toContacterDetail:(ContactBaseEntity*)entity{
//    E_ContacterType type;
//    if([entity isKindOfClass:[ContacterEntity class]]){
//        type = E_ContacterType_System;
//    }else if([entity isKindOfClass:[WXContacterEntity class]]){
//        type = E_ContacterType_WoXin;
//    }else if([entity isKindOfClass:[StrangerEntity class]]){
//        type = E_ContacterType_Stranger;
//    }
//    [[CoordinateController sharedCoordinateController] toContactDetail:self contactInfo:entity contactType:type animated:YES];
//}

#pragma mark modelDelegate
- (void)callHistoryChanged{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark keyBoardDelegate
- (void)showTitle{
    if(_keyPadNumber && [_keyPadNumber length] > 0){
//        [self setCSTTitle:_keyPadNumber];
        [_textView setText:_keyPadNumber];
        [_segmentControl setHidden:YES];
        [_textView setHidden:NO];
    }else{
//        [self setCSTTitle:kTitle];
        [_textView setHidden:YES];
        [_segmentControl setHidden:NO];
    }
}

- (WXTUITabBarController*)tabBarVC{
    return (WXTUITabBarController*)self.parentViewController;
}

- (void)upKeyBoardButtonClicked{
    if([_keyPadNumber length] > 0){
        [self showKeyBoardStatus:E_KeyPad_Form_TotalUp animated:YES];
    }else{
        [self showKeyBoardStatus:E_KeyPad_Form_PartUp animated:YES];
    }
}

- (void)showKeyBoardStatus:(E_KeyPad_State)status animated:(BOOL)animated{
    if(_keyPad.status == status){
        return;
    }
//	BOOL showTabBar = YES;
    CGRect keyPadRect;
	CGSize size = self.bounds.size;
    switch (status) {
        case E_KeyPad_Form_Down:
			[self.tabBarVC setTabBarHidden:NO aniamted:NO completion:^{
			}];
			size = self.bounds.size;
            keyPadRect = CGRectMake(0, size.height, size.width, kKeyPadHeight);
            break;
        case E_KeyPad_Form_PartUp:
			[self.tabBarVC setTabBarHidden:NO aniamted:NO completion:^{
			}];
			size = self.bounds.size;
            keyPadRect = CGRectMake(0, size.height - kKeyPadHeight + kBtnHeight, size.width, kKeyPadHeight);
            break;
        case E_KeyPad_Form_TotalUp:
			[self.tabBarVC setTabBarHidden:YES aniamted:NO completion:^{
			}];
			size = self.bounds.size;
            keyPadRect = CGRectMake(0, size.height - kKeyPadHeight, size.width, kKeyPadHeight);
            break;
        default:
            break;
    }
    [_keyPad setStatus:status];
    if(animated){
        [UIView animateWithDuration:0.3 animations:^{
            [_keyPad setFrame:keyPadRect];
        } completion:^(BOOL finished) {
//            [self.tabBarVC setTabBarHidden:!showTabBar aniamted:NO completion:^{
//            }];
        }];
    }else{
        [_keyPad setFrame:keyPadRect];
//        [self.tabBarVC setTabBarHidden:!showTabBar aniamted:NO completion:^{
//        }];
    }
}

- (void)showCurrentKeyPadAndTitle{
    [self showTitle];
    if(_keyPadNumber && [_keyPadNumber length] > 0){
		[self showContacters:YES];
        [self showKeyBoardStatus:E_KeyPad_Form_TotalUp animated:NO];
    }else{
        [self showKeyBoardStatus:E_KeyPad_Form_PartUp animated:NO];
		[self showContacters:NO];
    }
    [self showTableView];
}

- (void)intputCharacter:(NSString*)ch{
    if(!_keyPadNumber){
        [self setKeyPadNumber:ch];
    }else{
        [self setKeyPadNumber:[NSString stringWithFormat:@"%@%@",_keyPadNumber,ch]];
    }
    [self showCurrentKeyPadAndTitle];
	_inEdit = NO;
}

- (void)keyBoardDown{
    [self showKeyBoardStatus:E_KeyPad_Form_Down animated:NO];
//    WXCallUITabBarVC *tabBarVC = [self tabBarVC];
//    [tabBarVC keyBoardHasDown];
}

//makeCall
- (void)makeCall{
//    [self makeCall:[[TelNOOBJ sharedTelNOOBJ] telNumberFromOrigin:_keyPadNumber]];
}

- (void)delSingleCharacter{
    if(!_keyPadNumber){
        return;
    }else{
        NSInteger length = [_keyPadNumber length];
        if(length > 0){
            [self setKeyPadNumber:[_keyPadNumber substringToIndex:length-1]];
        }
    }
    [self showCurrentKeyPadAndTitle];
}
- (void)delAllCharacter{
    [self setKeyPadNumber:@""];
    [self showCurrentKeyPadAndTitle];
}

#pragma 粘贴手机号功能
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action == @selector(paste:)){
        return YES;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)becomeFirstResponder{
    if([super becomeFirstResponder]){
        return YES;
    }
    return NO;
}

-(void)paste:(id)sender{
    [self resignFirstResponder];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString *phone = [[TelNOOBJ sharedTelNOOBJ] telNumberFromOrigin:board.string];
    [self setKeyPadNumber:phone];
    [_textView setText:[NSString stringWithFormat:@"%@",phone]];
    [self showCurrentKeyPadAndTitle];
    [self showTableView];
}

-(void)segmentControlChange:(UISegmentedControl *)segmentControl{
    if(segmentControl.selectedSegmentIndex == 0){
    }else{
    }
}

@end
