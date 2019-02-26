#import "TransferResult.h"

@interface TransferResult()
@end

@implementation TransferResult
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_labelV!=nil)
    {
        _label.text = _labelV;
    }
    _fromAccount.text = _fromAccountV;
    _toAccount.text = _toAccountV;
    _amount.text = _amountV;
}
@end
