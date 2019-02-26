#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
@import GoogleMobileAds;

@interface Util : NSObject

+(void)changeView:(UIViewController*)view :(NSString*)to;
+(void)toast:(UIViewController*)view :(NSString*)text;
+(void)alert:(UIViewController*)view :(NSString*)text;
+(void)autoHide:(UIAlertController*)a;
+(BOOL)saveKeychain:(NSString*)key :(NSString*)input;
+(NSString*)getKeychain:(NSString*)key;
+(BOOL)deleteKeychain:(NSString*)key;
+(void)showAd:(UIViewController*)view;
+(void)addBannerViewToView:(UIView *)bannerView :(UIViewController*)view;
+(NSString*)md5:(NSString*) input;

@end

#ifndef Util_h
#define Util_h


#endif /* Util_h */
