//
//  CallViewController.h
//  AiCall
//
//  Created by jjyo.kwan on 13-11-26.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//

#import "BaseViewController.h"


@interface CallViewController : BaseViewController


@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLable;
@property (nonatomic, strong) IBOutlet UILabel *stateLabel;
@property (nonatomic, strong) IBOutlet UIButton *handupButton;

@property (nonatomic, strong) IBOutlet UILabel *tipsLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneLabel;

@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) NSString *callPhone;

@end
