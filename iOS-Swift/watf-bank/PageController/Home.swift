import UIKit

class Home : UIViewController {
    
    @IBAction func push(_ sender: Any) {
        if SQLCipher.drop("fav") || SQLCipher.drop("cred") || KeyChain.delete("token") || KeyChain.delete("pin") || KeyChain.delete("ip") {
            Util.alert(self, "Clear Data Failed")
        }
        if SQLCipher.createFav() || SQLCipher.createCred() {
            Util.alert(self, "Create Table Failed")
        }
        Util.changeView(self, "Login")
    }
}
