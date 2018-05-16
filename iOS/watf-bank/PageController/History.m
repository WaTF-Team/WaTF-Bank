#import "History.h"

@interface History()
@end

@implementation History
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_table setDelegate:self];
    [_table setDataSource:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.fromAccountData = (self.fromAccountData==nil) ? [[NSMutableArray alloc] init] : self.fromAccountData;
        self.toAccountData = (self.toAccountData==nil) ? [[NSMutableArray alloc] init] : self.toAccountData;
        self.amountData = (self.amountData==nil) ? [[NSMutableArray alloc] init] : self.amountData;
        self.dateData = (self.dateData==nil) ? [[NSMutableArray alloc] init] : self.dateData;
        NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:[Util getKeychain:@"accountNo"],@"accountNo",[Util getKeychain:@"token"],@"token", nil];
        [Http post:@"transferHistory" :input :^(NSDictionary *res)
         {
             if(res==nil)
             {
                 [Util alert:self :@"Connection Problem"];
                 return;
             }
             if([[res[@"message"] lowercaseString] isEqualToString:@"success"])
             {
                 for (id transaction in res[@"transaction"]) {
                     [self.fromAccountData addObject:transaction[@"accountNo"]];
                     [self.toAccountData addObject:transaction[@"toAccountNo"]];
                     [self.amountData addObject:transaction[@"amount"]];
                     [self.dateData addObject:transaction[@"datetime"]];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.table reloadData];
                 });
             }
             else
             {
                 [Util alert:self :@"An Error Occurred"];
             }
         }];
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fromAccountData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *c = [tableView dequeueReusableCellWithIdentifier:@"celli"];
    if(c==nil)
    {
        c = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celli"];
    }
    c.fromAccount.text = [NSString stringWithFormat:@"%@ : %@",@"From",[_fromAccountData objectAtIndex:[indexPath row]]];
    c.toAccount.text = [NSString stringWithFormat:@"%@ : %@",@"To",[_toAccountData objectAtIndex:[indexPath row]]];
    c.amount.text = [NSString stringWithFormat:@"%@ : %@",@"Amount",[_amountData objectAtIndex:[indexPath row]]];
    c.date.text = [NSString stringWithFormat:@"%@ : %@",@"Date",[_dateData objectAtIndex:[indexPath row]]];
    return c;
}
@end
