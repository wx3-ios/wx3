//
//  NSString+Encrypt.m
//  Woxin3.0
//
//  Created by Elty on 1/12/15.
//  Copyright (c) 2015 le ting. All rights reserved.
//

#import "NSString+Encrypt.h"
#import "CommonCrypto/CommonDigest.h"
#import "GTMBase64.h"

@implementation NSString (Encrypt)

//MD5加密方式
-(NSString *) md5{
	const char *cStr = [self UTF8String];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), digest );
 
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
 
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
 
	return output;
}

//SHA1加密方式
- (NSString*) sha1
{
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
 
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
 
	CC_SHA1(data.bytes, data.length, digest);
 
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
 
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
 
	return output;
}

//当然也可以结合BASE64来使用,这里的BASE64编码使用 GTMBase64实现，需要导入
- (NSString *) sha1_base64
{
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
 
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
 
	CC_SHA1(data.bytes, data.length, digest);
 
	NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
	base64 = [GTMBase64 encodeData:base64];
 
	NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
	return output;
}

- (NSString *) md5_base64
{
	const char *cStr = [self UTF8String];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), digest );
 
	NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
	base64 = [GTMBase64 encodeData:base64];
 
	NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
	return output;
}

- (NSString *) base64
{
	NSData * data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	data = [GTMBase64 encodeData:data];
	NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return output;
}

+(NSString*) HloveyRC4:(NSString*)aInput key:(NSString*)aKey {
	NSMutableArray *iS = [[NSMutableArray alloc] initWithCapacity:256];
	NSMutableArray *iK = [[NSMutableArray alloc] initWithCapacity:256];
	
	for (int i= 0; i<256; i++) {
		[iS addObject:[NSNumber numberWithInt:i]];
	}
	
	int j=1;
	
	for (short i=0; i<256; i++) {
		
		UniChar c = [aKey characterAtIndex:i%aKey.length];
		
		[iK addObject:[NSNumber numberWithChar:c]];
	}
	
	j=0;
	
	for (int i=0; i<255; i++) {
		int is = [[iS objectAtIndex:i] intValue];
		UniChar ik = (UniChar)[[iK objectAtIndex:i] charValue];
		
		j = (j + is + ik)%256;
		NSNumber *temp = [iS objectAtIndex:i];
		[iS replaceObjectAtIndex:i withObject:[iS objectAtIndex:j]];
		[iS replaceObjectAtIndex:j withObject:temp];
		
	}
	
	int i=0;
	j=0;
	
	NSString *result = aInput;
	
	for (short x=0; x<[aInput length]; x++) {
		i = (i+1)%256;
		
		int is = [[iS objectAtIndex:i] intValue];
		j = (j+is)%256;
		
		int is_i = [[iS objectAtIndex:i] intValue];
		int is_j = [[iS objectAtIndex:j] intValue];
		
		int t = (is_i+is_j) % 256;
		int iY = [[iS objectAtIndex:t] intValue];
		
		UniChar ch = (UniChar)[aInput characterAtIndex:x];
		UniChar ch_y = ch^iY;
		
		result = [result stringByReplacingCharactersInRange:NSMakeRange(x, 1) withString:[NSString stringWithCharacters:&ch_y length:1]];
	}
	
	
	return result;
}

- (NSString*)rc4WithKey:(NSString*)key{
	return [[self class] HloveyRC4:self key:key];
}

//- (NSString*)urlEncoding{
//	NSString *newString = NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(
//					 kCFAllocatorDefault,
//					 (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
//					 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
//	if (newString) {
//		return newString;
//	}
//	return @"";
//}

- (NSString *)hexString{
	NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
	Byte *bytes = (Byte *)[myD bytes];
	//下面是Byte 转换为16进制。
	NSString *hexStr=@"";
	for(int i=0;i<[myD length];i++)
  
	{
		NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
  
		if([newHexStr length]==1)
			
			hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
  
		else
			
			hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
	} 
	return hexStr; 
}

@end
