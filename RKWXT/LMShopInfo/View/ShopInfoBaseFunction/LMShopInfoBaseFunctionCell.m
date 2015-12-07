//
//  LMShopInfoBaseFunctionCell.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoBaseFunctionCell.h"
#import "LMShopInfoDef.h"

@interface LMShopInfoBaseFunctionCell(){
    WXUILabel *_allGoodsLabel;
    WXUILabel *_newGoodsLabel;
    WXUILabel *_activityGoodsLabel;
    WXUILabel *_shopInfoLabel;
    
    NSArray *nameArr;
}
@end

@implementation LMShopInfoBaseFunctionCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        nameArr = @[@"全部商品", @"上新", @"促销", @"店铺动态"];
        CGFloat btnWidth = IPHONE_SCREEN_WIDTH/4-1;
        CGFloat btnHeight = 44;
        CGFloat labelWidth = btnWidth;
        CGFloat labelHeight = 16;
        for(int i = 0; i < [nameArr count]; i++){
            WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(btnWidth+1), (LMShopInfoBaseFunctionHeight-btnHeight)/2, btnWidth, btnHeight);
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            WXUILabel *commonLabel = [[WXUILabel alloc] init];
            switch (i) {
                case 0:
                    _allGoodsLabel = commonLabel;
                    break;
                case 1:
                    _newGoodsLabel = commonLabel;
                    break;
                case 2:
                    _activityGoodsLabel = commonLabel;
                    break;
                case 3:
                    _shopInfoLabel = commonLabel;
                    break;
                default:
                    break;
            }
            commonLabel.frame = CGRectMake(0, 3, labelWidth, labelHeight);
            [commonLabel setBackgroundColor:[UIColor clearColor]];
            [commonLabel setTextAlignment:NSTextAlignmentCenter];
            [commonLabel setTextColor:WXColorWithInteger(0x000000)];
            [commonLabel setFont:WXFont(15.0)];
            [button addSubview:commonLabel];
            
            WXUILabel *namelabel = [[WXUILabel alloc] init];
            namelabel.frame = CGRectMake(0, 3+labelHeight, labelWidth, labelHeight);
            [namelabel setBackgroundColor:[UIColor clearColor]];
            [namelabel setText:nameArr[i]];
            [namelabel setTextAlignment:NSTextAlignmentCenter];
            [namelabel setTextColor:WXColorWithInteger(0x969696)];
            [namelabel setFont:WXFont(10.0)];
            [button addSubview:namelabel];
        }
    }
    return self;
}

-(void)load{
    
}

-(void)buttonClicked:(id)sender{
    WXUIButton *btn = sender;
}

@end
