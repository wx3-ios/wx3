//
//  IncomingCallViewController.h
//  WjtCall
//
//  Created by jjyo.kwan on 14-2-25.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#define kTableViewHidden                @"TableViewHidden"
#define kContactsCallIdentifier         @"ContactsCallIdentifier"
@class RFSegmentView;

typedef enum{
    kCallSegmentIndex,
    kContactsSegmentIndex,
}ContactsCallIndex;

@interface ContactsCallViewController : WXUIViewController{
//    UITextField * inputText;
//    UISegmentedControl * segmentControl;
    NSInteger selectedSegmentIndex;
}
@property (nonatomic, strong) RFSegmentView * segmentControl;

@end




