#import "Util.h"
#import "Http.h"
#import "SqlCipher.h"

@interface Login : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *ipp;
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    [Util showAd:self];
    if(![[Http getIp] isEqualToString:_ipp.text])
    {
        _ipp.text = [Http getIp];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_ipp resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)push:(id)sender {
    _login.enabled = false;
    [Http setIp:_ipp.text];
    NSLog(@"Username:%@ Password:%@",_username.text,_password.text);
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:_username.text,@"username",_password.text,@"password", nil];
    [Http post:@"login" :input :^(NSDictionary *res){
        [Util deleteKeychain:@"token"];
        [Util deleteKeychain:@"accountNo"];
        self.login.enabled = true;
        if(res==nil)
        {
            [Util alert:self :@"Connection Problem"];
            return;
        }
        if([[res[@"message"] lowercaseString] isEqualToString:@"success"])
        {
            if([Util saveKeychain:@"token" :res[@"token"]] && [Util saveKeychain:@"accountNo" :res[@"accountNo"]])
            {
                [SqlCipher insert2:self.username.text :self.password.text];
                [Util changeView:self :@"Pin"];
            }
        }
        else if([[res[@"message"] lowercaseString] containsString:@"invalid"])
        {
            [Util alert:self :@"Invalid Username/Password"];
        }
        else
        {
            [Util alert:self :@"An Error Occurred"];
        }
    }];
}

@end
