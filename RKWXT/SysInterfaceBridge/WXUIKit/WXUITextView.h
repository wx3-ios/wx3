//
//  WXUITextView.h
//  CallTesting
//
//  Created by le ting on 4/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXUITextViewDelegate;
@interface WXUITextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic,assign)NSInteger limiteCharacters;
@property (nonatomic,assign)id<WXUITextViewDelegate>wxDelegate;

-(void)textChanged:(NSNotification*)notification;
@end


@protocol WXUITextViewDelegate <NSObject>
@optional
- (BOOL)wxTextViewShouldBeginEditing:(WXUITextView *)textView;
- (BOOL)wxTextViewShouldEndEditing:(WXUITextView *)textView;
- (void)wxTextViewDidBeginEditing:(WXUITextView *)textView;
- (void)wxTextViewDidEndEditing:(WXUITextView *)textView;
- (BOOL)wxTextView:(WXUITextView *)textView shouldChangeTextInRange:(NSRange)range
   replacementText:(NSString *)text;
- (void)wxTextViewDidChange:(WXUITextView *)textView;
- (void)wxTextViewDidChangeSelection:(WXUITextView *)textView;
- (BOOL)wxTextView:(WXUITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
- (BOOL)wxTextView:(WXUITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange;
@end