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
        _ = KeyChain.save("ip", ip.text!)
        let a = SQLCipher.createFav()
        let b = SQLCipher.createCred()
        if !(a||b) {
            Util.alert(self, "Create Table Failed")
            _ = SQLCipher.drop("fav")
            _ = SQLCipher.drop("cred")
            return
        }
        let payload = ["username":username.text!,"password":password.text!]
        Http().post(payload, "login", completionHandler: {(re: [String:Any]) in
            var res = re as! [String:String]
            self.login.isEnabled = true
            if let e = res["error"] {
                Util.alert(self, e)
            }
            else if res["message"] == "Success" {
                if KeyChain.save("token", res["token"]!) && KeyChain.save("accountNo", res["accountNo"]!) {
                    _ = SQLCipher.insertCred(self.username.text!, self.password.text!)
                    Util.changeView(self, "Pin")
                }
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
