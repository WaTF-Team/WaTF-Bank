import Foundation
import UIKit

class Http: NSObject, URLSessionDelegate {
    
    private static var ip = "127.0.0.1:5000"
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func post(_ payload: [String: String],_ api: String, completionHandler:@escaping ([String: Any]) -> ()) {
        var request = URLRequest(url: URL(string: "https://\(Http.getIp())/\(api)")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted )
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(["error":"Connection Failed"])
                return
            }
            let r = response as! HTTPURLResponse
            if r.statusCode != 200 {
                completionHandler(["error":"\(r.statusCode):\(HTTPURLResponse.localizedString(forStatusCode: r.statusCode))"])
                return
            }
            let tmp = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            if tmp! == nil {
                let res = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                completionHandler(res!)
            }
            else {
                let res = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                completionHandler(res!)
            }
        }
        task.resume()
    }
    
    static func setIp(_ ip: String) {
        self.ip = ip
    }
    
    static func getIp() -> String {
        return KeyChain.load("ip") ?? ip
    }
}
