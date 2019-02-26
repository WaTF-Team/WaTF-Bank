#import "Util.h"
#import "SqlCipher.h"
#import "Http.h"
#import "TransferResult.h"

@interface Favourite:UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@end

@implementation Favourite

NSArray *pickerData;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    pickerData = [SqlCipher selectAll];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_amount resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    return stringIsValid;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (IBAction)push:(id)sender {
    if([[SqlCipher selectAll] count]==0) return;
    NSString *accountNo = [SqlCipher select:[self pickerView:_picker titleForRow:[_picker selectedRowInComponent:0] forComponent:0]];
    if(accountNo==nil) return;
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:[Util getKeychain:@"accountNo"],@"accountNo",accountNo,@"toAccountNo",_amount.text,@"amount",[Util getKeychain:@"token"],@"token", nil];
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
            t.fromAccountV = [NSString stringWithFormat:@"%@ : %@",@"From",[Util getKeychain:@"accountNo"]];
            t.toAccountV = [NSString stringWithFormat:@"%@ : %@",@"To",[SqlCipher select:pickerData[[self.picker selectedRowInComponent:0]]]];
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
