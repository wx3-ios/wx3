//
//  DialView.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-5.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_PAD @[@"0", @"1", @"2ABCacb", @"3DEFdef", @"4GHIghi", @"5JKLjkl", @"6MNOmno", @"7PQRSpqrs", @"8TUVtuv", @"9WXYZwxyz"]
#define KEY_NUMBER @"0123456789"


@interface DialView : UIView

@property (nonatomic, weak) IBOutlet UIButton *displayButton;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UILabel *inputLabel;
@property (nonatomic, strong) NSMutableString *inputNumber;
@property (nonatomic, weak) IBOutlet UIButton *sipButton;//直拨/回拨

@property (assign, getter = isVisible) BOOL visible;

- (void)cleanAll;

@end
