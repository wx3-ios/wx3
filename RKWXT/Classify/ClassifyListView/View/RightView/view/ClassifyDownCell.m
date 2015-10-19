//
//  ClassifyDownCell.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyDownCell.h"
#import "ClassifyRightDef.h"
#import "ClassifyLeftTableViewCell.h"

@interface ClassifyDownCell(){
    NSMutableArray *_WXViews;
}
@end

@implementation ClassifyDownCell

- (void)dealloc{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _WXViews = [[NSMutableArray alloc] init];
        CGSize merchandiseSize = [self cpxViewSize];
        NSInteger xNumber = [self xNumber];
        CGFloat sideGap = [self sideGap];
        CGFloat cellWidth = [self bounds].size.width-ClassifyLeftViewWidth;
        CGFloat cellheight = [self cellHeight];
        CGFloat xgap = ClassifyLeftViewWidth;
        if(xNumber > 1){
            xgap = (cellWidth - sideGap*2 - xNumber* merchandiseSize.width)/(xNumber-1);
        }
        
        CGFloat yOffset = (cellheight - merchandiseSize.height)*2.0/3.0;
        CGFloat xOffset = sideGap;
        for(int i = 0; i < [self xNumber]; i++){
            WXCpxBaseView *merchandiseView = [self createSubCpxView];
            CGRect rect = merchandiseView.frame;
            rect.origin.y = yOffset;
            rect.origin.x = xOffset;
            [merchandiseView setFrame:rect];
            [self.contentView addSubview:merchandiseView];
            
            xOffset += xgap + merchandiseSize.width;
            [_WXViews addObject:merchandiseView];
        }
    }
    return self;
}

- (void)loadCpxViewInfos:(NSArray*)cpxViewInfos{
    for(WXCpxBaseView *merchandiseView in _WXViews){
        [merchandiseView unLoad];
        [merchandiseView setHidden:YES];
    }
    
    NSInteger count = [cpxViewInfos count];
    for(int i = 0; i < count; i++){
        WXCpxBaseView *merchandiseView = [_WXViews objectAtIndex:i];
        [merchandiseView setCpxViewInfo:[cpxViewInfos objectAtIndex:i]];
        [merchandiseView load];
        [merchandiseView setHidden:NO];
    }
}


- (CGSize)cpxViewSize{
    return CGSizeZero;
}
- (WXCpxBaseView*)createSubCpxView{
    return nil;
}

- (CGFloat)cellHeight{
    return 0.0;
}

- (NSInteger)xNumber{
    return 0;
}

- (CGFloat)sideGap{
    return 0.0;
}
@end
