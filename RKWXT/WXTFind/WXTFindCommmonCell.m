//
//  WXTFindCommmonCell.m
//  RKWXT
//
//  Created by SHB on 15/4/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTFindCommmonCell.h"
#import "WXRemotionImgBtn.h"
#import "FindEntity.h"

#define EveryCellShowNumber (3)

@interface WXTFindCommonCell(){
    NSMutableArray *listArr;
}
@end

@implementation WXTFindCommonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUserInteractionEnabled:YES];
        listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)load{
    if([listArr count] > 0){
        return;
    }
    
    NSArray *dataArr = self.cellInfo;
    
    CGRect rect = [self bounds];
    CGFloat btnWidth = rect.size.width/3-1;
    CGFloat btnHeight = btnWidth;
    __block NSInteger count = 0;
    for(NSInteger i = 0; i < ([dataArr count]/3+([dataArr count]%3>0?1:0)); i++){
        for(NSInteger j = 0; j < EveryCellShowNumber; j++){
            if(count > [dataArr count]-1){
                break;
            }
            FindEntity *entity = [dataArr objectAtIndex:count];
            
            WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            commonBtn.frame = CGRectMake(j*(btnWidth+1), i*(btnHeight+1), btnWidth, btnHeight);
            [commonBtn setBackgroundColor:[UIColor whiteColor]];
            //            [commonBtn setBackgroundImageOfColor:WXColorWithInteger(0xbababa) controlState:UIControlStateHighlighted];
            commonBtn.tag = entity.classifyID;
            [self.contentView addSubview:commonBtn];
            [listArr addObject:entity];
            
            CGFloat imgWidth = 30;
            CGFloat imgHeight = imgWidth;
            WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake((btnWidth-imgWidth)/2, 10+(btnHeight/2-imgHeight)/2, imgWidth, imgHeight)];
            [imgView setUserInteractionEnabled:NO];
            [imgView setCpxViewInfo:entity.icon_url];
            [imgView load];
            [commonBtn addSubview:imgView];
            
            CGFloat labelHeight = 15;
            WXUILabel *namelabel = [[WXUILabel alloc] init];
            namelabel.frame = CGRectMake(0, 18+btnHeight/2, btnWidth, labelHeight);
            [namelabel setBackgroundColor:[UIColor clearColor]];
            [namelabel setTextAlignment:NSTextAlignmentCenter];
            [namelabel setTextColor:WXColorWithInteger(0x414141)];
            [namelabel setFont:WXFont(12.0)];
            [namelabel setText:entity.name];
            [commonBtn addSubview:namelabel];
            
            //有可能没用
            WXUILabel *desLabel = [[WXUILabel alloc] init];
            desLabel.frame = CGRectMake(0, btnHeight/2+labelHeight+18, btnWidth, labelHeight);
            [desLabel setBackgroundColor:[UIColor clearColor]];
            [desLabel setTextAlignment:NSTextAlignmentCenter];
            [desLabel setTextColor:WXColorWithInteger(0xbababa)];
            [desLabel setFont:WXFont(9.0)];
            [commonBtn addSubview:desLabel];
            
            if(j != 2){
                WXUILabel *rightLine = [[WXUILabel alloc] init];
                rightLine.frame = CGRectMake(commonBtn.frame.origin.x+btnWidth+0.2, commonBtn.frame.origin.y, 0.2, btnHeight);
                [rightLine setBackgroundColor:WXColorWithInteger(0xbababa)];
                [self.contentView addSubview:rightLine];
            }
            
            WXUILabel *downLine = [[WXUILabel alloc] init];
            downLine.frame = CGRectMake(commonBtn.frame.origin.x, commonBtn.frame.origin.y+btnHeight, btnWidth, 0.2);
            [downLine setBackgroundColor:WXColorWithInteger(0xbababa)];
            [self.contentView addSubview:downLine];
            
            count++;
        }
    }
}

@end
