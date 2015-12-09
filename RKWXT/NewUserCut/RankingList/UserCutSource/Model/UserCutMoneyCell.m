//
//  UserCutMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutMoneyCell.h"
#import "MyRefereeEntity.h"

@interface UserCutMoneyCell(){
    WXUILabel *moneyLabel;
}
@end

@implementation UserCutMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat yOffset = 13;
        CGFloat smallWidth = 80;
        CGFloat smallHeight = 20;
        moneyLabel = [[WXUILabel alloc] init];
        moneyLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-smallWidth)/2, yOffset, smallWidth, smallHeight);
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        [moneyLabel setText:@"0.00"];
        [moneyLabel setTextAlignment:NSTextAlignmentCenter];
        [moneyLabel setFont:WXFont(15.0)];
        [moneyLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:moneyLabel];
    
        yOffset += smallHeight;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-smallWidth)/2, yOffset, smallWidth, smallHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setText:@"提成"];
        [textLabel setTextColor:WXColorWithInteger(0x828282)];
        [textLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:textLabel];
    }
    return self;
}

-(void)load{
    MyRefereeEntity *entity = self.cellInfo;
    [moneyLabel setText:[NSString stringWithFormat:@"%.2f",entity.cutMoney]];
}

@end
