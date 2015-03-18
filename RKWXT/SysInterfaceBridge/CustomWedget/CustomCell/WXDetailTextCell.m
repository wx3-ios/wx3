//
//  WXDetailTextCell.m
//  CallTesting
//
//  Created by le ting on 5/13/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXDetailTextCell.h"

@interface WXDetailTextCell()
{
    WXUIImageView *_detailImgView;
}
@end

@implementation WXDetailTextCell
@synthesize detailImgView = _detailImgView;

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
        [self.textField setEnabled:NO];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGSize size = frame.size;
    CGRect rect = _detailImgView.frame;
    rect.origin.x = size.width - rect.size.width - 10;
    rect.origin.y = (size.height - rect.size.height)*0.5;
    [_detailImgView setFrame:rect];
    
    UITextField *txtField = self.textField;
    CGRect txtFieldRect = txtField.frame;
    txtFieldRect.size.width -= (size.width - rect.origin.x);
    [txtField setFrame:txtFieldRect];
}

@end
