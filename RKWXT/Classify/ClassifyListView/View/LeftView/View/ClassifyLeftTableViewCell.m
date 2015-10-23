//
//  ClassifyLeftTableViewCell.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyLeftTableViewCell.h"
#import "CLassifyEntity.h"

@interface ClassifyLeftTableViewCell(){
    WXUILabel *textLabel;
}

@end

@implementation ClassifyLeftTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat textLabelHeight = 25;
        textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(0, (ClassifyLeftViewHeight-textLabelHeight)/2, ClassifyLeftViewWidth, textLabelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setTextColor:WXColorWithInteger(0x000000)];
        [textLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    CLassifyEntity *entity = self.cellInfo;
    [textLabel setText:entity.catName];
    if([entity.catName isEqualToString:_selectedStr]){
        [textLabel setTextColor:WXColorWithInteger(0xdd2726)];
    }else{
        [textLabel setTextColor:WXColorWithInteger(0x000000)];
    }
}

@end
