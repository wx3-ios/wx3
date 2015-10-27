//
//  GoodsInfoDownView.m
//  RKWXT
//
//  Created by SHB on 15/10/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "GoodsInfoDownView.h"
#import "GoodsInfoEntity.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

@interface GoodsInfoDownView(){
    UIView *_maskShell;
    UIView *_baseView;
    
    CGFloat viewHeight;
    
    CGFloat _duration;
    CGFloat _maskAlpha;
}
@end

@implementation GoodsInfoDownView

-(id)init{
    self = [super init];
    if(self){
        [self initial];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initial];
    }
    return self;
}

-(void)initial{
    _maskShell = [[UIView alloc] init];
    [_maskShell setFrame:self.bounds];
    [_maskShell setBackgroundColor:[UIColor blackColor]];
    [_maskShell setAlpha:kMaskShellDefaultAlpha];
    [self addSubview:_maskShell];
}

-(void)sharebtnClicked:(WXUIButton*)btn{
    [self unshow];
}

-(void)showDownView:(CGFloat)downViewHeight toDestview:(UIView *)destView{
    self.hidden = NO;
    self.alpha = 0.0;
    viewHeight = downViewHeight;
    
    [_maskShell setFrame:destView.bounds];
    [self setFrame:destView.bounds];
    [destView addSubview:self];
    
    [self showDownView];
    
    __block GoodsInfoDownView *blockSelf = self;
    [UIView animateWithDuration:_duration animations:^{
        [blockSelf show];
    }];
}

-(void)showDownView{
    GoodsInfoEntity *entity = nil;
    if([_dataArr count] > 0){
        entity = [_dataArr objectAtIndex:0];
    }
    _baseView = [[UIView alloc] init];
    [_baseView setFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH, viewHeight)];
    [_baseView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_baseView];
    
    CGFloat xOffset = 10;
    CGFloat yOffset = 8;
    CGFloat textlabelWidth = 100;
    CGFloat textLabelHeight = 22;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-textlabelWidth)/2, xOffset, textlabelWidth, textLabelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"服务说明"];
    [textLabel setFont:WXFont(16.0)];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [_baseView addSubview:textLabel];
    
    yOffset += textLabelHeight+18;
    if(entity.use_red){
        WXUIImageView *imgView1 = [[WXUIImageView alloc] init];
        imgView1.frame = CGRectMake(15, yOffset+5, 10, 10);
        [imgView1 setImage:[UIImage imageNamed:@"AddressSelNormal.png"]];
        [_baseView addSubview:imgView1];
        
        WXUILabel *redPacket = [[WXUILabel alloc] init];
        redPacket.frame = CGRectMake(imgView1.frame.origin.x+10+10, yOffset, 100, textLabelHeight);
        [redPacket setBackgroundColor:[UIColor clearColor]];
        [redPacket setText:@"使用红包"];
        [redPacket setTextAlignment:NSTextAlignmentLeft];
        [redPacket setTextColor:WXColorWithInteger(0x000000)];
        [redPacket setFont:WXFont(9)];
        [_baseView addSubview:redPacket];
        
        yOffset += textLabelHeight;
        NSString *redText = @"该商品可使用红包，如果您的红包尚有余额，那么您可以在下单时候选择是否适用红包，使用红包可以抵用一部分现金。";
        CGSize redSize = [self sizeForString:redText font:WXFont(9.0) constrainedToSize:CGSizeMake(IPHONE_SCREEN_WIDTH-redPacket.frame.origin.x-10, 0) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat redTextHeight = redSize.height*2.5;
        WXUILabel *redInfo = [[WXUILabel alloc] init];
        redInfo.frame = CGRectMake(redPacket.frame.origin.x, yOffset, IPHONE_SCREEN_WIDTH-redPacket.frame.origin.x-10, redTextHeight);
        [redInfo setBackgroundColor:[UIColor clearColor]];
        [redInfo setText:redText];
        [redInfo setTextAlignment:NSTextAlignmentLeft];
        [redInfo setTextColor:WXColorWithInteger(0x9b9b9b)];
        [redInfo setFont:WXFont(12)];
        [redInfo setNumberOfLines:0];
        [_baseView addSubview:redInfo];
        
        yOffset += redTextHeight+10;
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [_baseView addSubview:lineLabel];
        if(!entity.use_cut){
            [lineLabel setHidden:YES];
        }
        yOffset += 0.5+10;
    }
    if(entity.use_cut){
        WXUIImageView *imgView2 = [[WXUIImageView alloc] init];
        imgView2.frame = CGRectMake(15, yOffset+5, 10, 10);
        [imgView2 setImage:[UIImage imageNamed:@"AddressSelNormal.png"]];
        [_baseView addSubview:imgView2];
        
        WXUILabel *cutLabel = [[WXUILabel alloc] init];
        cutLabel.frame = CGRectMake(imgView2.frame.origin.x+10+10, yOffset, 100, textLabelHeight);
        [cutLabel setBackgroundColor:[UIColor clearColor]];
        [cutLabel setText:@"提成"];
        [cutLabel setTextAlignment:NSTextAlignmentLeft];
        [cutLabel setTextColor:WXColorWithInteger(0x000000)];
        [cutLabel setFont:WXFont(9)];
        [_baseView addSubview:cutLabel];
        
        yOffset += textLabelHeight;
        NSString *cutText = @"该商品有分成，如果您有推荐人，那么在您购买该商品后，您的推荐人将会获得一部分分成。";
        CGSize cutSize = [self sizeForString:cutText font:WXFont(9.0) constrainedToSize:CGSizeMake(IPHONE_SCREEN_WIDTH-cutLabel.frame.origin.x-10, 0) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat cutTextHeight = cutSize.height*2.5;
        WXUILabel *cutInfo = [[WXUILabel alloc] init];
        cutInfo.frame = CGRectMake(cutLabel.frame.origin.x, yOffset, IPHONE_SCREEN_WIDTH-cutLabel.frame.origin.x-10, cutTextHeight);
        [cutInfo setBackgroundColor:[UIColor clearColor]];
        [cutInfo setText:cutText];
        [cutInfo setTextAlignment:NSTextAlignmentLeft];
        [cutInfo setTextColor:WXColorWithInteger(0x9b9b9b)];
        [cutInfo setFont:WXFont(12)];
        [cutInfo setNumberOfLines:0];
        [_baseView addSubview:cutInfo];
    }
    WXUIButton *closeBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, viewHeight-40, IPHONE_SCREEN_WIDTH, 40);
    [closeBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(isClicked) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:closeBtn];
    
    _duration = kAnimateDefaultDuration;
    _maskAlpha = kMaskShellDefaultAlpha;
    
    [self setUserInteractionEnabled:YES];
}

- (void)show{
    [self setAlpha:1.0];
    [UIView animateWithDuration:_duration animations:^{
        [_baseView setFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT-viewHeight, IPHONE_SCREEN_WIDTH, viewHeight)];
    }completion:^(BOOL finished) {
    }];
}

- (void)unshow{
    [_baseView setFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH, viewHeight)];
    [self setAlpha:0.0];
}

- (void)unshowAnimated:(BOOL)animated{
    if (animated){
        __block GoodsInfoDownView *blockSelf = self;
        [UIView animateWithDuration:_duration animations:^{
            [blockSelf unshow];
        } completion:^(BOOL finished) {
            [blockSelf removeFromSuperview];
        }];
        
    }else{
        [self removeFromSuperview];
    }
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)isClicked{
    [self unshowAnimated:YES];
}

@end
