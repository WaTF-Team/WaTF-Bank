#import "Util.h"
#import "Http.h"

@interface Summary:UIViewController
@property (weak, nonatomic) IBOutlet UILabel *accountNo;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *username;
@end

@implementation Summary
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:[Util getKeychain:@"accountNo"],@"accountNo",[Util getKeychain:@"token"],@"token", nil];
    [Http post:@"accountSummary" :input :^(NSDictionary *res)
     {
         if(res==nil)
         {
             [Util alert:self :@"Connection Problem"];
             return;
         }
         if([[res[@"message"] lowercaseString] isEqualToString:@"success"])
         {
             self.username.text = [NSString stringWithFormat:@"%@ : %@",@"Username",res[@"username"]];
             self.tel.text = [NSString stringWithFormat:@"%@ : %@",@"Telephone",res[@"tel"]];
             self.balance.text = [NSString stringWithFormat:@"%@ : %@",@"Balance",res[@"balance"]];
             self.accountNo.text = [NSString stringWithFormat:@"%@ : %@",@"Account No",[Util getKeychain:@"accountNo"]];
         }
         else
         {
             [Util alert:self :@"An Error Occurred"];
         }
     }];
}
@end
