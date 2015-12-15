//
//  LMEvaluteGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMEvaluteGoodsCell.h"
#import "WXRemotionImgBtn.h"

@interface LMEvaluteGoodsCell(){
    WXRemotionImgBtn *imgView;
}
@end

@implementation LMEvaluteGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat xOffset = 10;
        CGFloat imgWidth = 62;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMEvaluteGoodsCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat textHeight = 60;
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(xOffset, 15, IPHONE_SCREEN_WIDTH-xOffset-10, textHeight);
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setPlaceholder:@"请输入评价内容"];
        [_textField setTextColor:WXColorWithInteger(0x646464)];
        [_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_textField addTarget:self action:@selector(textfieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_textField addTarget:self action:@selector(textFiledValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)textfieldDone:(id)sender{
    [sender resignFirstResponder];
}

-(void)textFiledValueDidChanged:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(userEvaluteTextFieldChanged:)]){
        [_delegate userEvaluteTextFieldChanged:self];
    }
}

-(void)load{
    
}

@end
