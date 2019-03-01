import UIKit

class Transfer : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var accountNo: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    override func viewDidLoad() {
        accountNo.delegate = self
        amount.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowChar = CharacterSet(charactersIn: "0123456789")
        return  allowChar.isSuperset(of: CharacterSet(charactersIn: string)) && (textField.text!.count+string.count)<=10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accountNo.resignFirstResponder()
        amount.resignFirstResponder()
    }
    
    @IBAction func push(_ sender: Any) {
        guard let token = KeyChain.load("token"), let acc = KeyChain.load("accountNo") else {
            Util.alert(self, "Invalid Token")
            return
        }
        let input = ["accountNo":acc,"toAccountNo":accountNo.text!,"amount":amount.text!,"token":token]
        Http().post(input, "transfer", completionHandler: {(re: [String:Any]) in
            var res = re as! [String:String]
            if let e = res["error"] {
                Util.alert(self, e)
            }
            else if res["message"] == "Success" {
                let t = self.storyboard!.instantiateViewController(withIdentifier: "TransferResult") as! TransferResult
                t.labelV = "Transfer Succeeded"
                t.fromAccountV = "From : "+res["username"]!
                t.toAccountV = "To : "+res["toAccount"]!
                t.amountV = "Amount : "+res["amount"]!
                self.present(t, animated: true, completion: nil)
            }
            else if let m = res["message"] {
                Util.alert(self, m)
            }
            else {
                Util.alert(self, "An Error Occurred")
            }
        })
    }
}
