//
//  WXUITextView.m
//  CallTesting
//
//  Created by le ting on 4/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUITextView.h"

@interface WXUITextView()<UITextViewDelegate>
{
    UIColor *_placeholderColor;
}
@property (nonatomic, retain) WXUILabel *placeHolderLabel;
@end

@implementation WXUITextView


CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    RELEASE_SAFELY(_placeholderColor);
    RELEASE_SAFELY(_placeHolderLabel);
    RELEASE_SAFELY(_placeholder)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        _limiteCharacters = NSIntegerMax;
        _placeholderColor = [UIColor grayColor];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        [self setDelegate:self];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0)
        {
            [[self viewWithTag:999] setAlpha:1];
        }
        else
        {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[WXUILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

#pragma mark
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextViewShouldBeginEditing:)]){
        return [_wxDelegate wxTextViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextViewShouldEndEditing:)]){
        return [_wxDelegate wxTextViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextViewDidBeginEditing:)]){
        [_wxDelegate wxTextViewDidBeginEditing:self];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextViewDidEndEditing:)]){
        [_wxDelegate wxTextViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    BOOL b = textView.text.length + (text.length - range.length) <= _limiteCharacters;
    if([@"" isEqualToString:text] && !b){
        self.text=[self.text substringToIndex:_limiteCharacters ];
    }
    if(_wxDelegate && [_wxDelegate respondsToSelector:
                       @selector(wxTextView:shouldChangeTextInRange:replacementText:)]){
        return [_wxDelegate wxTextView:self shouldChangeTextInRange:range replacementText:text];
    }else{
        //如果不是默认的就屏蔽换行
        if(self.returnKeyType != UIReturnKeyDefault){
            if([text rangeOfString:@"\n"].location != NSNotFound){
                [textView resignFirstResponder];
                return NO;
            }
        }
        return b;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextViewDidChange:)]){
        [_wxDelegate wxTextViewDidChange:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextViewDidChangeSelection:)]){
        [_wxDelegate wxTextViewDidChangeSelection:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextView:shouldInteractWithURL:inRange:)]){
        return [_wxDelegate wxTextView:self shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    if(_wxDelegate && [_wxDelegate respondsToSelector:@selector(wxTextView:shouldInteractWithTextAttachment:inRange:)]){
        return [_wxDelegate wxTextView:self shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}


@end
