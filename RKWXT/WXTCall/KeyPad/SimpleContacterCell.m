//
//  SimpleContacterCell.m
//  Woxin2.0
//
//  Created by le ting on 7/31/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SimpleContacterCell.h"
#import "SysContacterEntityEx.h"

@implementation SimpleContacterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.textLabel setFont:WXFont(16.0)];
        [self.textLabel setTextColor:WXColorWithInteger(0x323232)];
        
        [self.detailTextLabel setFont:WXFont(12.0)];
        [self.detailTextLabel setTextColor:WXColorWithInteger(0x969696)];
    }
    return self;
}

- (void)load{
    [super load];
    SysContacterEntityEx *entityEx = self.cellInfo;
    ContacterEntity *contacter = entityEx.contactEntity;
    
    NSString *phoneNumber = entityEx.phoneMatched;
    NSString *name = nil;
    if(contacter){
        name = contacter.name;
    }
    if(name){
        [self.textLabel setText:name];
        [self.detailTextLabel setText:phoneNumber];
    }else{
        [self.textLabel setText:phoneNumber];
    }
}

@end
