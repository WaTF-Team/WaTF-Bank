#import <Foundation/Foundation.h>

@interface Http : NSObject <NSURLSessionDelegate>

+(void)setIp:(NSString*)ip;
+(NSString*)getIp;
+(void)post:(NSString*)api :(NSDictionary*)data :(void (^)(NSDictionary *res))completion;

@end

#ifndef Http_h
#define Http_h


#endif /* Http_h */
