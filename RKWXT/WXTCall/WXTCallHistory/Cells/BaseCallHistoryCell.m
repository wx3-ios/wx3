//
//  BaseCallHistoryCell.m
//  Woxin2.0
//
//  Created by le ting on 7/31/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "BaseCallHistoryCell.h"
#import "CallHistoryEntity.h"

@implementation BaseCallHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setDefaultAccessoryView:E_CellDefaultAccessoryViewType_Detail];
    }
    return self;
}

@end
