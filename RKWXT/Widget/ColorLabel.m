//
//  ColorLabel.m
//  Okboo
//
//  Created by jjyo.kwan on 12-8-20.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import "ColorLabel.h"

@implementation ColorLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver:self forKeyPath:@"highlighted" options:0 context:nil];
    }
    return self;
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"highlighted"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"highlighted"]) {
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect
{
   

    if (!_colorMode || _ranges.count == 0 || self.text.length == 0) {
        [super drawRect:rect];
        return;
    }
    
    
    UIColor *rgColor = self.highlighted ? _rangeHighlightedColor : _rangeColor;
    UIColor *customColor = rgColor ? rgColor : [UIColor redColor];
    UIColor *textColor = self.highlighted ? self.highlightedTextColor : self.textColor;                                                
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    int lastIndex = 0;
    CGSize stringSize = [self textSize:self.text];
    int yOffset = (self.frame.size.height - stringSize.height) / 2;
    
    for (int i = 0; i < _ranges.count; i++)
    {
        NSRange prevRange = i > 0 ? [[_ranges objectAtIndex:i-1] rangeValue] : NSMakeRange(0, 0);
        NSRange range = [[_ranges objectAtIndex:i] rangeValue];
        
        //中间
        NSRange amongRange = [self NSAmongRangeLeft:prevRange right:range];
        if (amongRange.length > 0) {
            
            [self drawRange:amongRange withColor:textColor context:context yOffset:yOffset];
        }
        if (range.length > 0) {
            [self drawRange:range withColor:customColor context:context yOffset:yOffset];
            lastIndex = range.location + range.length;
        }
        
    }

    //last 
    if (lastIndex > 0) {
        [self drawRange:NSMakeRange(lastIndex, self.text.length - lastIndex) withColor:textColor context:context yOffset:yOffset];
    }
    else{
        [super drawRect:rect];
    }
}


- (void)drawRange:(NSRange)range withColor:(UIColor *)color context:(CGContextRef)context yOffset:(int)y
{

    
    
    NSString *subString = [self.text substringWithRange:range];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    //计算前一须字符窜的长度
    NSString *prevString = [self.text substringToIndex:range.location];
    CGSize size = [self textSize:prevString];
//    int yOffset = (self.frame.size.height - size.height) / 2;
    [subString drawAtPoint:CGPointMake(size.width, y) withFont:self.font];
//    CGRect rect = CGRectMake(size.width, self.frame.origin.y, self.frame.size.width - size.width, self.frame.size.height);
//    [subString drawInRect:rect withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
    

//    [subString drawInRect:rect withFont:self.font];
//    NSLog(@"prevString = %@  size = %@", prevString, NSStringFromCGSize(size));
//    NSLog(@"%@ draw point at %@  android range = %@", subString, NSStringFromCGPoint(CGPointMake(size.width, 0)), NSStringFromRange(range));
}



- (NSRange)NSAmongRangeLeft:(NSRange)left right:(NSRange)right
{
    int location =left.length > 0 ? left.location + left.length : 0;
    int length = right.length > 0 ? right.location - location : 0;
    return NSMakeRange(location, length);
}

- (void)setRanges:(NSArray *)ranges
{
    _ranges = ranges;
    [self setNeedsDisplay];
}


- (CGSize)textSize:(NSString *)text
{
    if (text == nil || text.length == 0) {
        return CGSizeMake(0, 0);
    }
    return [text sizeWithFont:self.font constrainedToSize:CGSizeMake(1000, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
}


@end
