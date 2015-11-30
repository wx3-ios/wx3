//
//  HomeLimitBuyTitleCell.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "HomeLimitBuyTitleCell.h"
#import "NewHomePageCommonDef.h"

@implementation HomeLimitBuyTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat nameWidth = 100;
        CGFloat nameHeight = 20;
        WXUILabel *namelabel = [[WXUILabel alloc] init];
        namelabel.frame = CGRectMake(xOffset, (T_HomePageTextSectionHeight-nameHeight)/2, nameWidth, nameHeight);
        [namelabel setBackgroundColor:[UIColor clearColor]];
        [namelabel setText:@"限时购"];
        [namelabel setTextAlignment:NSTextAlignmentLeft];
        [namelabel setTextColor:WXColorWithInteger(0x000000)];
        [namelabel setFont:WXFont(TextFont)];
        [self.contentView addSubview:namelabel];
        
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-nameWidth-12, (T_HomePageTextSectionHeight-nameHeight)/2, nameWidth, nameHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentRight];
        [textLabel setTextColor:WXColorWithInteger(0x000000)];
        [textLabel setFont:WXFont(12.0)];
        [textLabel setText:@"查看更多"];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    
}

@end
