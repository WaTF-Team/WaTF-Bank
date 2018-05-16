#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface SqlCipher : NSObject

+(BOOL)create;
+(BOOL)insert:(NSString*)input :(NSString*)input2;
+(BOOL)del:(NSString*)input;
+(NSString*)select:(NSString*)input;
+(NSMutableArray*)selectAll;
+(BOOL)create2;
+(BOOL)insert2:(NSString*)input :(NSString*)input2;
+(BOOL)del2:(NSString*)input;
+(NSString*)select2:(NSString*)input;
+(NSMutableArray*)selectAll2;
+(BOOL)drop:(NSString*)input;
+(void)cipherKey;

@end

#ifndef SqlCipher_h
#define SqlCipher_h


#endif /* SqlCipher_h */
