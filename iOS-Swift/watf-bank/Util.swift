import Foundation
import UIKit

class Util {
    
    static func changeView(_ view: UIViewController, _ to: String) {
        view.present(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: to), animated: true, completion: nil)
    }
    
    static func alert(_ view: UIViewController, _ text: String) {
        let a = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(a, animated: true, completion: nil)
    }
}
