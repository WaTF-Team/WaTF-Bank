import UIKit
import LocalAuthentication
import CommonCrypto

class Pin : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pinText: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        pinText.delegate = self
        if KeyChain.load("pin") != nil {
            label.text = "Enter PIN"
        }
    }
    
    @IBAction func push(_ sender: Any) {
        if let pin = KeyChain.load("pin") {
            if pin == md5(pinText.text!) {
                Util.changeView(self, "Home")
            }
            else {
                Util.alert(self, "Invalid PIN")
            }
        }
        else {
            if pinText.text!.count == 4 {
                if !KeyChain.save("pin", md5(pinText.text!)) {
                    Util.alert(self, "An Error Occured")
                }
                else {
                    Util.changeView(self, "Home")
                }
            }
            else {
                Util.alert(self, "Please Insert 4-digit PIN")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if KeyChain.load("pin") == nil {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentication") {
                    [unowned self] success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            Util.changeView(self, "Home")
                        }
                        else {
                            Util.alert(self, "Too Many Errors")
                        }
                    }
                }
            }
            else {
                Util.alert(self, "Check Your Touch ID")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowChar = CharacterSet(charactersIn: "0123456789")
        return  allowChar.isSuperset(of: CharacterSet(charactersIn: string)) && (textField.text!.count+string.count)<=4
    }
    
    func md5(_ text: String) -> String {
        let messageData = text.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.base64EncodedString()
    }
}
