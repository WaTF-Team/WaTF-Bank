import UIKit

class AddFavourite : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var accountNo: UITextField!
    
    override func viewDidLoad() {
        accountNo.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        name.resignFirstResponder()
        accountNo.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowChar = CharacterSet(charactersIn: "0123456789")
        return  allowChar.isSuperset(of: CharacterSet(charactersIn: string)) && (textField.text!.count+string.count)<=10
    }
    
    @IBAction func push(_ sender: Any) {
        if SQLCipher.insertFav(name.text!, accountNo.text!) {
            let a = UIAlertController(title: "Add Succeeded", message: nil, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .default, handler: {(ac) in
                    Util.changeView(self, "Home")
                }))
            self.present(a, animated: true, completion: nil)
        }
        else {
            Util.alert(self, "Add Failed")
        }
    }
}
