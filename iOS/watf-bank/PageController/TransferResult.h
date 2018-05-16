#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TransferResult : UIViewController
@property (assign, nonatomic) NSString *amountV;
@property (assign, nonatomic) NSString *toAccountV;
@property (assign, nonatomic) NSString *fromAccountV;
@property (assign, nonatomic) NSString *labelV;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *toAccount;
@property (weak, nonatomic) IBOutlet UILabel *fromAccount;
@end

#ifndef TransferResult_h
#define TransferResult_h


#endif /* TransferResult_h */
