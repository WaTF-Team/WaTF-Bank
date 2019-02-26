#import "Util.h"
#import "Http.h"
#import "HistoryCell.h"

@interface History:UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *fromAccountData;
@property (strong, nonatomic) NSMutableArray *toAccountData;
@property (strong, nonatomic) NSMutableArray *amountData;
@property (strong, nonatomic) NSMutableArray *dateData;
@property NSInteger row;
@end

#ifndef History_h
#define History_h


#endif /* History_h */
