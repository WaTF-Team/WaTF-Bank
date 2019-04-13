#import <LocalAuthentication/LocalAuthentication.h>
#import "Util.h"

@interface Pin:UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pin;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation Pin

bool fingerprint = true;

- (void)viewDidLoad {
    [super viewDidLoad];
    _pin.delegate = self;
    if([Util getKeychain:@"pin"]!=nil)
    {
        _label.text = @"Enter Your PIN";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    BOOL lengthIsValid = ([textField.text length]+[string length]>4);
    return stringIsValid && !lengthIsValid;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_pin resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    if([Util getKeychain:@"pin"]==nil)
    {
        return;
    }
    if(fingerprint)
    {
        LAContext *context = [[LAContext alloc] init];
        NSError *err = nil;
        NSString *reason = @"Authentication";
        fingerprint = false;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:reason
                                reply:^(BOOL success, NSError *error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (success)
                                        {
                                            fingerprint = true;
                                            [Util changeView:self :@"Home"];
                                        }
                                        else if(error.code==-1)
                                        {
                                            [Util alert:self :@"Too many failed attemps"];
                                        }
                                        else if(error.code!=-2&&error.code!=-3)
                                        {
                                            [Util alert:self :@"An Error Occured"];
                                        }
                                    });
                                }];
        } else {
            [Util alert:self :@"Check Your Touch ID"];
        }
    }
}

- (IBAction)push:(id)sender {
    if([Util getKeychain:@"pin"]!=nil)
    {
        if([self checkPin])
        {
            fingerprint = true;
            [self nextPage];
        }
        else
        {
            [Util alert:self :@"Invalid PIN"];
        }
    }
    else
    {
        if([_pin.text length]!=4)
        {
            [Util alert:self :@"Please Insert 4-Digit Pin"];
        }
        else if([Util saveKeychain:@"pin" :[Util md5:_pin.text]])
        {
            fingerprint = true;
            [self nextPage];
        }
        else
        {
            [Util alert:self :@"An Error Occured"];
        }
    }
}

-(BOOL)checkPin
{
    return [[Util getKeychain:@"pin"] isEqualToString:[Util md5:_pin.text]];
}

-(void)nextPage
{
    [Util changeView:self :@"Home"];
}

@end
