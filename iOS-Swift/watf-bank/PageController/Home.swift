import UIKit

class Home : UIViewController {
    
    @IBAction func push(_ sender: Any) {
        let a = SQLCipher.drop("fav")
        let b = SQLCipher.drop("cred")
        let c = KeyChain.delete("token")
        let d = KeyChain.delete("pin")
        let e = KeyChain.delete("ip")
        if !(a||b||c||d||e) {
            let a = UIAlertController(title: "Clear Data Failed", message: nil, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .default, handler: {(ac) in
                Util.changeView(self, "Login")
            }))
            self.present(a, animated: true, completion: nil)
        }
        Util.changeView(self, "Login")
    }
}
