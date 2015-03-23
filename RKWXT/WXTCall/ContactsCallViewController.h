//
//  IncomingCallViewController.h
//  WjtCall
//
//  Created by jjyo.kwan on 14-2-25.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

//#import "BaseViewController.h"
typedef enum{
    kCallSegmentIndex,
    kContactsSegmentIndex,
}ContactsCallIndex;

@interface ContactsCallViewController : BaseVC{
    UITextField * inputText;
//    UISegmentedControl * segmentControl;
    NSInteger selectedSegmentIndex;
}
@property (nonatomic, strong) UISegmentedControl * segmentControl;

@end



