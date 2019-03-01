import UIKit

class TransferResult : UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var fromAccount: UILabel!
    @IBOutlet weak var toAccount: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    var labelV = ""
    var fromAccountV = ""
    var toAccountV = ""
    var amountV = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelV
        fromAccount.text = fromAccountV
        toAccount.text = toAccountV
        amount.text = amountV
    }
}
