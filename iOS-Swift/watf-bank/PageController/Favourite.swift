import UIKit

class Favourite : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    
    var pickerData = SQLCipher.selectAll("fav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amount.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowChar = CharacterSet(charactersIn: "0123456789")
        return  allowChar.isSuperset(of: CharacterSet(charactersIn: string))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func push(_ sender: Any) {
        if pickerData.count == 0 {
            Util.alert(self, "No Favourite")
            return
        }
        guard let token = KeyChain.load("token"), let acc = KeyChain.load("accountNo") else {
            Util.alert(self, "token")
            return
        }
        let toAcc = SQLCipher.selectFav(pickerView(picker, titleForRow: picker.selectedRow(inComponent: 0), forComponent: 0)!)[0]
        let input = ["accountNo":acc,"toAccountNo":toAcc,"amount":amount.text!,"token":token]
        Http().post(input, "transfer", completionHandler: {(res: [String:String]) in
            if let e = res["error"] {
                Util.alert(self, e)
            }
            else if res["message"] == "success" {
                let t = self.storyboard!.instantiateViewController(withIdentifier: "TransferResult") as! TransferResult
                t.fromAccount.text = "From : "+res["username"]!
                t.toAccount.text = "To : "+res["tel"]!
                t.amount.text = "Amount : "+res["balance"]!
                self.present(t, animated: true, completion: nil)
            }
            else {
                Util.alert(self, "An Error Occurred")
            }
        })
    }
    
}
