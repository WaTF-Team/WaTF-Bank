import UIKit

class History : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var fromAccountData = Array<String>()
    var toAccountData = Array<String>()
    var amountData = Array<String>()
    var dateData = Array<String>()
    
    override func viewDidLoad() {
        table.delegate = self
        table.dataSource = self
        DispatchQueue.main.async {
            guard let token = KeyChain.load("token"), let acc = KeyChain.load("accountNo") else {
                Util.alert(self, "Invalid Token")
                return
            }
            let input = ["accountNo":acc,"token":token]
            Http().post(input, "transferHistory", completionHandler: {(res: [String:Any]) in
                if let e = res["error"] {
                    Util.alert(self, e as! String)
                }
                else if res["message"] as! String == "success" {
                    for transaction in res["transaction"] as! Array<Any> {
                        let t = (try? JSONSerialization.jsonObject(with: (transaction as! String).data(using: .utf8)!, options: [])) as! [String:String]
                        self.fromAccountData.append(t["accountNo"]!)
                        self.toAccountData.append(t["toAccountNo"]!)
                        self.amountData.append(t["amount"]!)
                        self.dateData.append(t["datetime"]!)
                    }
                }
                else {
                    Util.alert(self, "An Error Occurred")
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fromAccountData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cc = tableView.dequeueReusableCell(withIdentifier: "celli")
        if cc==nil {
            cc = HistoryCell.init(style: .default, reuseIdentifier: "celli")
        }
        let c = cc as! HistoryCell
        c.fromAccount.text = "From : "+fromAccountData[indexPath.row]
        c.toAccount.text = "From : "+toAccountData[indexPath.row]
        c.amount.text = "From : "+amountData[indexPath.row]
        c.date.text = "From : "+dateData[indexPath.row]
        return c
    }
    
    
}
