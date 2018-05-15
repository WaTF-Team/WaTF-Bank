#import "Http.h"
#import "Util.h"

@interface Http() <NSURLSessionDelegate>
@end

@implementation Http

static NSString *ip;

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

+(void)setIp:(NSString *)ipp
{
    if(ip==nil)
    {
        ip = [[NSString alloc] init];
    }
    ip = ipp;
}

+(NSString*)getIp
{
    if(ip==nil)
    {
        [self setIp:@"192.168.1.1"];
    }
    return ip;
}

+(void)post:(NSString*)api :(NSDictionary*)data :(void (^)(NSDictionary *res))completion
{
    NSString *url = [NSString stringWithFormat:@"https://%@:5000/",ip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,api]]];
    NSError *e = nil;
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&e]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[self alloc] delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                                           NSURLResponse * _Nullable response,
                                                                           NSError * _Nullable error) {
        NSError *e = nil;
        if(data==nil)
        {
            completion(nil);
            return;
        }
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        completion(res);
    }];
    [task resume];
}

@end
