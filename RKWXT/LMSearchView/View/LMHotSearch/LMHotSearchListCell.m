//
//  LMHotSearchListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/9.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMHotSearchListCell.h"

#define kTimerInterval (5.0)
#define kOneCellShowNumber (3)

@interface LMHotSearchListCell(){
    WXUIView *baseView;
    NSArray *listArr;
}
@end

@implementation LMHotSearchListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    }
    return self;
}

-(void)load{
    if(baseView){
        [baseView removeFromSuperview];
    }
    baseView = [[WXUIView alloc] init];
    baseView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 50);
    [baseView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [self.contentView addSubview:baseView];
    
    listArr = self.cellInfo;
    if([listArr count] == 0){
        return;
    }
    CGFloat xOffset = 10;
    CGRect rect = [self bounds];
    CGFloat btnWidth = (rect.size.width-((kOneCellShowNumber+1)*xOffset))/kOneCellShowNumber;
    CGFloat btnHeight = 26;
    CGFloat yGap = 8;
    NSInteger count = 0;
    for(NSInteger j = 0; j < ([listArr count]/kOneCellShowNumber+([listArr count]%kOneCellShowNumber>0?1:0)); j++){
        for(NSInteger i = 0; i < kOneCellShowNumber; i++){
            if(count > [listArr count]-1){
                break;
            }
//            ShopUnionClassifyEntity *entity = [classifyArr objectAtIndex:count];
            
            WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            [commonBtn setBackgroundColor:WXColorWithInteger(0xffffff)];
            [commonBtn setBackgroundImageOfColor:[UIColor colorWithRed:0.951 green:0.886 blue:0.793 alpha:1.000] controlState:UIControlStateHighlighted];
            [commonBtn setEnabled:NO];
            commonBtn.frame = CGRectMake(xOffset+i*(xOffset+btnWidth), yGap+j*(btnHeight+yGap), btnWidth, btnHeight);
            [commonBtn setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xdbdbdb)];
            [commonBtn setTitle:[listArr objectAtIndex:count] forState:UIControlStateNormal];
            [commonBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
            [commonBtn.titleLabel setFont:WXFont(12.0)];
//            commonBtn.tag = entity.industryID;
            [commonBtn addTarget:self action:@selector(buttonImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            [baseView addSubview:commonBtn];
            
            count++;
        }
    }
    
    NSInteger number = [listArr count]/kOneCellShowNumber+([listArr count]%kOneCellShowNumber>0?1:0);
    CGRect rect1 = baseView.frame;
    if(number == 0){
        rect1.size.height = 0;
    }
    rect1.size.height = yGap + (yGap+btnHeight)*number;
    [baseView setFrame:rect1];
}

- (void)buttonImageClicked:(id)sender{
    WXUIButton *btn = sender;
    if(_delegate && [_delegate respondsToSelector:@selector(lmHotSearchlistBtnClicked:)]){
        [_delegate lmHotSearchlistBtnClicked:btn.tag];
    }
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    CGFloat yOffset = 8;
    NSArray *arr = cellInfo;
    NSInteger number = [arr count]/kOneCellShowNumber+([arr count]%kOneCellShowNumber>0?1:0);
    if(number == 0){
        return 0;
    }
    CGFloat height = yOffset + (yOffset+26)*number;
    return height;
}

@end
