//
//  NSString+Encrypt.h
//  Woxin3.0
//
//  Created by Elty on 1/12/15.
//  Copyright (c) 2015 le ting. All rights reserved.
//

@interface NSString (Encrypt)
-(NSString *) md5;//MD5加密方式
- (NSString*) sha1;//SHA1加密方式
- (NSString *) sha1_base64;//sha1+base64
- (NSString *) md5_base64;//md5+base64
- (NSString *) base64; //base64
- (NSString*)rc4WithKey:(NSString*)key;//rc4加密~
- (NSString*)urlEncoding;
- (NSString *)hexString;//16进制
@end
