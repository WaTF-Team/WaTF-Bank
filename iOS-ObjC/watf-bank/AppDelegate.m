#import "AppDelegate.h"
#import "JailbreakDetection.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static bool bgState = false;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    bgState = false;
    if(![JailbreakDetection isJail])
    {
        if([url.scheme isEqualToString:@"watf"])
        {
            if([url.host isEqualToString:@"transfer"])
            {
                NSArray *q = [url.query componentsSeparatedByString:@"&"];
                if(q.count==3)
                {
                    NSString *from,*to,*amount;
                    for (int i=0; i<3; i++) {
                        if([[q[i] componentsSeparatedByString:@"="][0] isEqualToString:@"fromAccount"])
                        {
                            from = [q[i] componentsSeparatedByString:@"="][1];
                        }
                        else if([[q[i] componentsSeparatedByString:@"="][0] isEqualToString:@"toAccount"])
                        {
                            to = [q[i] componentsSeparatedByString:@"="][1];
                        }
                        else if([[q[i] componentsSeparatedByString:@"="][0] isEqualToString:@"amount"])
                        {
                            amount = [q[i] componentsSeparatedByString:@"="][1];
                        }
                        else
                        {
                            return false;
                        }
                    }
                    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:from,@"accountNo",to,@"toAccountNo",amount,@"amount",[Util getKeychain:@"token"],@"token", nil];
                    [Http post:@"transfer" :input :^(NSDictionary *res)
                     {
                         UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                         
                         while (topViewController.presentedViewController) {
                             topViewController = topViewController.presentedViewController;
                         }
                         TransferResult *t = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"TransferResult"];
                         if([[res[@"message"] lowercaseString] isEqualToString:@"success"])
                         {
                             t.labelV = nil;
                             t.fromAccountV = [NSString stringWithFormat:@"%@ : %@",@"From",from];
                             t.toAccountV = [NSString stringWithFormat:@"%@ : %@",@"To",to];
                             t.amountV = [NSString stringWithFormat:@"%@ : %@",@"Amount",amount];
                         }
                         else
                         {
                             t.labelV = @"Transfer Failed";
                             t.fromAccountV = [NSString stringWithFormat:@"%@ : %@",@"From",from];
                             t.toAccountV = [NSString stringWithFormat:@"%@ : %@",@"To",to];
                             t.amountV = [NSString stringWithFormat:@"%@ : %@",@"Amount",amount];
                         }
                         self.window.rootViewController = t;
                     }];
                }
            }
        }
    }
    else
    {
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Jailbreak"];

    }
    return true;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if([Util getKeychain:@"ip"]!=nil)
    {
        [Http setIp:[Util getKeychain:@"ip"]];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    bgState = true;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface
    if(bgState)
    {
        bgState = false;
        if([JailbreakDetection isJail])
        {
            self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Jailbreak"];
            return;
        }
        if([Util getKeychain:@"token"]==nil)
        {
            self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        }
        else
        {
            self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Pin"];
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
