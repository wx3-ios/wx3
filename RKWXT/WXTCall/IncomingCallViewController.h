//
//  IncomingCallViewController.h
//  WjtCall
//
//  Created by jjyo.kwan on 14-2-25.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

//#import "BaseViewController.h"


@interface IncomingCallViewController : BaseVC

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UIView *miniHeadView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLable;
@property (nonatomic, strong) IBOutlet UILabel *stateLabel;
@property (nonatomic, strong) IBOutlet UIButton *handupButton;
@property (nonatomic, strong) IBOutlet UIButton *keypadButton;
@property (nonatomic, strong) IBOutlet UILabel *callTimeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) IBOutlet UILabel *miniTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *miniSubtitleLabel;


@property (nonatomic, strong) IBOutlet NSLayoutConstraint *headHeightLayoutConstraint;


@property (nonatomic, strong) NSString *callPhone;

@end


