//
//  LMEvaluteUserHandleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMEvaluteUserHandleCell.h"

@interface LMEvaluteUserHandleCell(){
    WXUIButton *firstBtn;
    WXUIButton *secondBtn;
    WXUIButton *thirdBtn;
    WXUIButton *forthBtn;
    WXUIButton *fivethBtn;
}
@end

@implementation LMEvaluteUserHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 60;
        CGFloat labelHeight = 18;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMEvaluteUserHandleCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"描述相符"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:nameLabel];
        
        CGFloat btnWidth = 20;
        CGFloat btnHeight = btnWidth;
        CGFloat xGap = 20+btnWidth;
        firstBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        firstBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMEvaluteUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [firstBtn setBackgroundColor:[UIColor clearColor]];
        [firstBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [firstBtn setTag:1];
        [firstBtn addTarget:self action:@selector(evaluteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:firstBtn];
        
        xGap += btnWidth+5;
        secondBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        secondBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMEvaluteUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [secondBtn setBackgroundColor:[UIColor clearColor]];
        [secondBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [secondBtn setTag:2];
        [secondBtn addTarget:self action:@selector(evaluteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:secondBtn];
        
        xGap += btnWidth+5;
        thirdBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        thirdBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMEvaluteUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [thirdBtn setBackgroundColor:[UIColor clearColor]];
        [thirdBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [thirdBtn setTag:3];
        [thirdBtn addTarget:self action:@selector(evaluteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:thirdBtn];
        
        xGap += btnWidth+5;
        forthBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        forthBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMEvaluteUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [forthBtn setBackgroundColor:[UIColor clearColor]];
        [forthBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [forthBtn setTag:4];
        [forthBtn addTarget:self action:@selector(evaluteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:forthBtn];
        
        xGap += btnWidth+5;
        fivethBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        fivethBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, (LMEvaluteUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [fivethBtn setBackgroundColor:[UIColor clearColor]];
        [fivethBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [fivethBtn setTag:5];
        [fivethBtn addTarget:self action:@selector(evaluteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:fivethBtn];
    }
    return self;
}

-(void)load{
    NSInteger sign = 0;
    if(sign == 0){
        [firstBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [thirdBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [forthBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [fivethBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
    }
    if(sign == 1){
        [firstBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [thirdBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [forthBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [fivethBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
    }
    if(sign == 2){
        [firstBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [thirdBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [forthBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [fivethBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
    }
    if(sign == 3){
        [firstBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [thirdBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [forthBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
        [fivethBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
    }
    if(sign == 4){
        [firstBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [thirdBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [forthBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [fivethBtn setImage:[UIImage imageNamed:@"EvaluteEmptyImg.png"] forState:UIControlStateNormal];
    }
    if(sign == 5){
        [firstBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [thirdBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [forthBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
        [fivethBtn setImage:[UIImage imageNamed:@"EvaluteFullImg.png"] forState:UIControlStateNormal];
    }
}

-(void)evaluteBtnClicked:(id)sender{
//    WXUIButton *btn = sender;
    
}

@end
