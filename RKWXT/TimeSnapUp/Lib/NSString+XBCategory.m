

#import "NSString+XBCategory.h"

@implementation NSString (XBCategory)
+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font maxW:(CGFloat)maxW{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(maxW, MAXFLOAT);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size ;
    
}

+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font maxH:(CGFloat)maxH{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(MAXFLOAT,maxH);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size ;
}


+ (CGSize)sizeWithString:(NSString*)string font:(UIFont*)font{
    return [self sizeWithString:string font:font maxW:MAXFLOAT];
}

+ (NSMutableAttributedString*)changeFontAddColor:(NSString*)rootStr  sonStr:(NSString*)sonStr fontColor:(UIColor*)fontColor font:(UIFont*)font {
    //设置带属性的字体
    NSMutableAttributedString *atter = [[NSMutableAttributedString alloc]initWithString:rootStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    dict[NSForegroundColorAttributeName] = fontColor;
    
    [atter addAttributes:dict range:[rootStr rangeOfString:sonStr]];
    
    return atter;
}

+ (NSMutableAttributedString*)changeFontAddColor:(NSString*)rootStr  sonStr:(NSString*)sonStr fontColor:(UIColor*)fontColor {
    NSMutableAttributedString *atter = [[NSMutableAttributedString alloc]initWithString:rootStr ];
    
    [atter addAttribute:NSForegroundColorAttributeName value:fontColor range:[rootStr rangeOfString:sonStr]];
    
    return atter;
}
@end
