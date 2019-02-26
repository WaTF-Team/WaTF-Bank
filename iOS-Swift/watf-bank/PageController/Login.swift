import UIKit

class Login : UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var ip: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ip.text = Http.getIp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
        ip.resignFirstResponder()
        login.resignFirstResponder()
    }
    
    @IBAction func push(_ sender: Any) {
        login.isEnabled = false
        Http.setIp(ip.text!)
        let payload = ["username":username.text!,"password":password.text!]
        Http().post(payload, "login", completionHandler: {(res: [String:String]) in
            self.login.isEnabled = true
            if let e = res["error"] {
                Util.alert(self, e)
            }
            else if res["message"] == "success" {
                if KeyChain.save("token", res["token"]!) && KeyChain.save("accountNo", res["accountNo"]!) {
                    _ = SQLCipher.insertCred(self.username.text!, self.password.text!)
                    Util.changeView(self, "Pin")
                }
            }
            else if res["message"] == "invalid" {
                Util.alert(self, "Invalid Username/Password")
            }
            else {
                Util.alert(self, "An Error Occurred")
            }
        })
    }
}
