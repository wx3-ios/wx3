//
//  BaseInfoCommonCell.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseInfoCommonCell.h"

@interface BaseInfoCommonCell(){
    UILabel *_infoLabel;
}
@end

@implementation BaseInfoCommonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 25;
        CGFloat nameLabelWitdh = 100;
        CGFloat nameLabelHeight = 16;
        CGSize size = self.bounds.size;
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(size.width-xOffset-nameLabelWitdh, (size.height-nameLabelHeight)/2, nameLabelWitdh, nameLabelHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentRight];
        [_infoLabel setFont:WXFont(12.0)];
        [_infoLabel setTextColor:WXColorWithInteger(0x979797)];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

-(void)load{
    NSString *str = self.cellInfo;
    [_infoLabel setText:str];
}

@end
