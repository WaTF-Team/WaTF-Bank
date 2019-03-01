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
                else if res["message"] as! String == "Success" {
                    for transaction in res["transaction"] as! Array<Any> {
                        let t = transaction as! [String:String]
                        self.fromAccountData.append(t["accountNo"]!)
                        self.toAccountData.append(t["toAccountNo"]!)
                        self.amountData.append(t["amount"]!)
                        self.dateData.append(t["datetime"]!)
                    }
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
                else if let m = res["message"] {
                    Util.alert(self, m as! String)
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
        var c : HistoryCell
        if let cc = tableView.dequeueReusableCell(withIdentifier: "celli") {
            c = cc as! HistoryCell
        }
        else {
            c = HistoryCell.init(style: .default, reuseIdentifier: "celli")
        }
        c.fromAccount.text = "From : "+fromAccountData[indexPath.section]
        c.toAccount.text = "To : "+toAccountData[indexPath.section]
        c.amount.text = "Amount : "+amountData[indexPath.section]
        c.date.text = "Date : "+dateData[indexPath.section]
        return c
    }
}
