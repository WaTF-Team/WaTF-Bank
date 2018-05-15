#import "Util.h"
#import "Http.h"
#import "History.h"
#import "SqlCipher.h"

@interface Home : UIViewController

@end

@implementation Home
- (void)viewDidLoad
{
    [SqlCipher create];
    [SqlCipher create2];
}

- (IBAction)push:(id)sender {
    [SqlCipher drop:@"fav"];
    [SqlCipher drop:@"cred"];
    [SqlCipher create];
    [SqlCipher create2];
    [Util deleteKeychain:@"token"];
    [Util deleteKeychain:@"pin"];
    [Util deleteKeychain:@"ip"];
    [Util changeView:self :@"Login"];
}
@end
