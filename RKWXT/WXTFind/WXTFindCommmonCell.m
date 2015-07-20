//
//  WXTFindCommmonCell.m
//  RKWXT
//
//  Created by SHB on 15/4/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTFindCommmonCell.h"
#import "DBImageView.h"

@interface WXTFindCommmonCell(){
    DBImageView *_imgView;
    UILabel *_nameLabel;
}
@end

@implementation WXTFindCommmonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat imgWidth = 30;
        CGFloat imgHeight = 30;
        _imgView = [[DBImageView alloc] init];
        _imgView.frame = CGRectMake(xOffset, (FindCommonCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [_imgView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+20;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 25;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, (FindCommonCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXTFont(14.0)];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

-(void)load{
    [_imgView setImage:[UIImage imageNamed:_img]];
    [_nameLabel setText:_name];
}

@end
