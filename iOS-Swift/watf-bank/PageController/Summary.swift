import UIKit

class Summary : UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var accountNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let token = KeyChain.load("token"), let acc = KeyChain.load("accountNo") else {
            Util.alert(self, "Invalid Token")
            return
        }
        let input = ["accountNo":acc,"token":token]
        Http().post(input, "accountSummary", completionHandler: {(res: [String:String]) in
            if let e = res["error"] {
                Util.alert(self, e)
            }
            else if res["message"] == "success" {
                self.username.text = "Username : "+res["username"]!
                self.tel.text = "Telephone : "+res["tel"]!
                self.balance.text = "Balance : "+res["balance"]!
                self.accountNo.text = "Account No : "+acc
            }
            else {
                Util.alert(self, "An Error Occurred")
            }
        })
    }
}
