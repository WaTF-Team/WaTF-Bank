import Foundation
import UIKit

class Http: NSObject, URLSessionDelegate {
    
    static var ip = "192.168.1.1"
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func post(_ payload: [String: String],_ api: String, completionHandler:@escaping ([String: String]) -> ()) {
        var request = URLRequest(url: URL(string: "\(Http.ip)\(api)")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(["error":"Connection Failed"])
                return
            }
            
            let res = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
            completionHandler(res!)
        }
        task.resume()
    }
    
    static func setIp(_ ip: String) {
        self.ip = ip
    }
    
    static func getIp() -> String {
        return ip
    }
}
