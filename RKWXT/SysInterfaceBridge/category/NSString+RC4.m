//
//  NSString+RC4.m
//  Woxin3.0
//
//  Created by Elty on 1/12/15.
//  Copyright (c) 2015 le ting. All rights reserved.
//

#import "NSString+RC4.h"

@implementation NSString (RC4)

typedef struct rc4_key_str
{
	unsigned char state[256];
	unsigned char x;
	unsigned char y;
} rc4_key;

static void swap_byte(unsigned char *a, unsigned char *b);

void prepare_key(unsigned char *key_data_ptr,
				 int key_data_len,
				 rc4_key *key)
{
	unsigned char index1;
	unsigned char index2;
	unsigned char* state;
	short counter;
	
	state = &key->state[0];
	for(counter = 0; counter < 256; counter++)
		state[counter] = counter;
	key->x = 0;
	key->y = 0;
	index1 = 0;
	index2 = 0;
	for(counter = 0; counter < 256; counter++)
	{
		index2 = (key_data_ptr[index1] + state[counter] +
				  index2) % 256;
		swap_byte(&state[counter], &state[index2]);
		
		index1 = (index1 + 1) % key_data_len;
	}
}

void rc4(unsigned char *buffer_ptr, int buffer_len,  rc4_key *key)
{
	unsigned char x;
	unsigned char y;
	unsigned char* state;
	unsigned char xorIndex;
	short counter;
	
	x = key->x;
	y = key->y;
	
	state = &key->state[0];
	for(counter = 0; counter < buffer_len; counter ++)
	{
		x = (x + 1) % 256;
		y = (state[x] + y) % 256;
		swap_byte(&state[x], &state[y]);
		
		xorIndex = (state[x] + state[y]) % 256;
		
		buffer_ptr[counter] ^= state[xorIndex];
	}
	key->x = x;
	key->y = y;
}

static void swap_byte(unsigned char *a, unsigned char *b)
{
	unsigned char swapByte;
	
	swapByte = *a;
	*a = *b;
	*b = swapByte;
}

static void rc4Decrypt(char *key, char *data){
	unsigned char seed[5] = "chsh";
	rc4_key rc4key;
	
	prepare_key(seed,	strlen(key),	&rc4key);
	rc4((unsigned char *)data, strlen(data), &rc4key);
	return;
}

- (NSString*)rc4EncryptWithKey:(NSString*)key{
	const char *cstring = [self cStringUsingEncoding:NSUTF8StringEncoding];
	char buffer[256];
	memset(buffer, 0, sizeof(buffer));
	memcpy(buffer, cstring, [self length]);
	rc4Decrypt((char*)[key cStringUsingEncoding:NSUTF8StringEncoding],buffer);
	NSString *newString = [NSString stringWithFormat:@"%s",buffer];
	return newString;
}

@end
