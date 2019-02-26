#import "Util.h"
#import "Http.h"
#import "TransferResult.h"

@interface Transfer:UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *accountNo;
@end

@implementation Transfer
- (void)viewDidLoad
{
    _amount.delegate = self;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_amount resignFirstResponder];
    [_accountNo resignFirstResponder];
}


- (IBAction)push:(id)sender {
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:[Util getKeychain:@"accountNo"],@"accountNo",_accountNo.text,@"toAccountNo",_amount.text,@"amount",[Util getKeychain:@"token"],@"token", nil];
    [Http post:@"transfer" :input :^(NSDictionary *res)
     {
         if(res==nil)
         {
             [Util alert:self :@"Connection Problem"];
             return;
         }
         if([[res[@"message"] lowercaseString] isEqualToString:@"success"])
         {
             TransferResult *t = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferResult"];
             t.fromAccountV = [Util getKeychain:@"accountNo"];
             t.toAccountV = self.accountNo.text;
             t.amountV = self.amount.text;
             t.fromAccountV = [NSString stringWithFormat:@"%@ : %@",@"From",[Util getKeychain:@"accountNo"]];
             t.toAccountV = [NSString stringWithFormat:@"%@ : %@",@"To",self.accountNo.text];
             t.amountV = [NSString stringWithFormat:@"%@ : %@",@"Amount",self.amount.text];
             [self presentViewController:t animated:true completion:nil];
         }
         else
         {
             [Util alert:self :@"An Error Occurred"];
         }
     }];
}
@end
