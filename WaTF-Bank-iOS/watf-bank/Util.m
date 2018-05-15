#import "Util.h"

@interface Util()
@end

@implementation Util

static GADBannerView *bannerView;
static NSUserDefaults *userdefault;

+(NSString*)md5:(NSString*) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+(void)showAd:(UIViewController*)view
{
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    bannerView.rootViewController = view;
    [self addBannerViewToView:bannerView :view];
    [bannerView loadRequest:[GADRequest request]];
}

+(void)addBannerViewToView:(UIView *)bannerView :(UIViewController*)view
{
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [view.view addSubview:bannerView];
    [view.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}

+(void)changeView:(UIViewController*)view :(NSString*)to
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:to];
    [view presentViewController:vc animated:YES completion:nil];
}

+(void)toast:(UIViewController*)view :(NSString*)text
{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:text
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    [self performSelector:@selector(autoHide:) withObject:alert afterDelay:1.5];
    [view presentViewController:alert animated:YES completion:nil];
}

+(void)alert:(UIViewController*)view :(NSString*)text
{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:text
                                message:nil
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                         }];
        [alert addAction:ok];
    [view presentViewController:alert animated:YES completion:nil];
}

+(void)autoHide:(UIAlertController*)a{
    [a dismissViewControllerAnimated:YES completion:nil];
}

+(BOOL)saveKeychain:(NSString*)key :(NSString*)input
{
    NSData* data = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *add = @{(id)kSecClass:(id)kSecClassGenericPassword,
                         (id)kSecAttrAccount:key,
                         (id)kSecValueData:data
                          };
    OSStatus s = SecItemAdd((__bridge CFDictionaryRef)add, nil);
    if(s!=errSecSuccess) return false;
    return true;
}

+(NSString*)getKeychain:(NSString*)key
{
    CFTypeRef data;
    NSDictionary *get = @{(id)kSecClass:(id)kSecClassGenericPassword,
                          (id)kSecAttrAccount:key,
                          (id)kSecReturnData:(id)kCFBooleanTrue
                          };
    OSStatus s = SecItemCopyMatching((__bridge CFDictionaryRef)get, &data);
    if(s!=errSecSuccess) return nil;
    return [[NSString alloc] initWithData:(__bridge_transfer NSData *)data encoding:NSUTF8StringEncoding];
}

+(BOOL)deleteKeychain:(NSString*)key
{
    NSDictionary *del = @{(id)kSecClass:(id)kSecClassGenericPassword,
                          (id)kSecAttrAccount:key
                          };
    OSStatus s = SecItemDelete((__bridge CFDictionaryRef)del);
    if(s!=errSecSuccess) return false;
    return true;
}

@end
