#import "Util.h"
#import "SqlCipher.h"

@interface AddFavourite : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountNo;
@property (weak, nonatomic) IBOutlet UITextField *name;
@end

@implementation AddFavourite

- (void)viewDidLoad
{
    _accountNo.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    BOOL lengthIsValid = ([textField.text length]+[string length]>10);
    return stringIsValid && !lengthIsValid;
}

- (IBAction)push:(id)sender {
    if([SqlCipher insert:_name.text :_accountNo.text])
    {
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"Add Favourite Success"
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [Util changeView:self :@"Home"];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [Util alert:self :@"Add Favourite Failed"];
    }
}

@end
