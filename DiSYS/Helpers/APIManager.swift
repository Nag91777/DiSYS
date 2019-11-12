//
//  APIManager.swift
//

import Foundation
import UIKit

class APIManager: NSObject {
    
    static let shared = APIManager()
    typealias Result = (_ response: Any?, _ error: String?) -> Void
    var SESSION_ID : String = ""

    func request(urlAppend: String, httpMethod: String, contentType: String, params: [String: Any]?, bodyStr: String?, delegate: UIViewController?, showSpinner: Bool = true ,completion: @escaping Result) {
        //prepare url
        guard let url = URL(string: Constants.APP_URL + urlAppend) else {
            completion(nil, Error.noValidURL.errorDescription)
           return
        }
        //prepare request
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Constants.TIME_OUT)
        request.httpMethod = httpMethod
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        //set body
        if let data = getBodyData(params: params, bodyStr: bodyStr){
            request.httpBody = data
        }
        //set   on id
       // if !SESSION_ID.isEmpty {
        let headers = ["consumer-key" : "mobile_dev_dysis",
                       "consumer-secret" : "8c6e5807397f41dfbc7f61cc049c7ef0"]
            request.allHTTPHeaderFields = headers
        //}
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //show spinner
        if showSpinner{
            showOrHideSpinner(isShow: true, delegate: delegate)
        }
        print("Url: \(url)")
        print("Body params: \(params)")
        print("body str: \(bodyStr)")
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            //hide spinner
            DispatchQueue.main.async {
                if showSpinner == true{
                    self.showOrHideSpinner(isShow: false, delegate: delegate)
                }
            }
            if error == nil && response != nil, let data = data {
                var result: Any?
                do{
                    result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch {
                    DispatchQueue.main.async {
                        completion(nil, "Failed to convert data to json")
                    }
                    return
                }
                if let result = result {
                    print("result: \(result)")
                    if urlAppend == "login.json"{
                        self.setSessionId(response: response)
                    }
                    DispatchQueue.main.async {
                        completion(result, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, "No Data")
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    var message = String.giveMeProperString(str: error?.localizedDescription)
                    if message.isEmpty {
                        message = Constants.MSG_DEFAULT
                    }
                    completion(nil, message)
                }
            }
        })
        dataTask.resume()
    }
    
    func setSessionId(response: URLResponse?) {
        if let response = response as? HTTPURLResponse {
            if let headers = response.allHeaderFields as? [String: Any] {
                let sessionId = String.giveMeProperString(str: headers["Set-Cookie"])
                self.SESSION_ID = sessionId
            }
        }
    }
    
    func getBodyData(params: [String: Any]?, bodyStr: String?) -> Data? {
        var reqData: Data?
        if let params = params, params.count > 0 {
            do {
                reqData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch { }
        } else if let bodyStr = bodyStr, bodyStr.count > 0 {
            if let body = bodyStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                reqData = body.data(using: String.Encoding.utf8)
            }
        }
        return reqData
    }
    
    func showOrHideSpinner(isShow: Bool, delegate: UIViewController?){
        if isShow == true{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let controller = delegate {
                MBProgressHUD.showAdded(to: controller.view, animated: true)
            }
        }else{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let controller = delegate {
                MBProgressHUD.hide(for: controller.view, animated: true)
            }
        }
    }
    
    func generateBoundaryString() -> String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func requestFormData(urlAppend: String, params: [[String: String]], delegate: UIViewController?, completion: @escaping Result) {
        //prepare url
        guard let url = URL(string: Constants.APP_URL + urlAppend) else {
            completion(nil, Error.noValidURL.errorDescription)
            return
        }
        //prepare request
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
        let boundary = generateBoundaryString()
        let headers = [
            "consumer-key" : "mobile_dev",
            "consumer-secret" : "20891a1b4504ddc33d42501f9c8d2215fbe85008",
            "content-type": "application/x-www-form-urlencoded"
        ]
        //"content-type": "application/x-www-form-urlencoded",
        var body = Data()
        for dict in params {
            let paramName = dict["name"]!
            let paramValue = dict["value"]!
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(paramName)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(paramValue)\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpMethod = Constants.POST
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        print("Url: \(url)")
        print("Body params: \(params)")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //show spinner
        showOrHideSpinner(isShow: true, delegate: delegate)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            //hide spinner
            DispatchQueue.main.async {
                self.showOrHideSpinner(isShow: false, delegate: delegate)
            }
            if error == nil && response != nil, let data = data {
                var result: Any?
                do{
                    result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch {
                    DispatchQueue.main.async {
                        completion(nil, "Failed to convert data to json")
                    }
                    return
                }
                if let result = result {
                    print("result: \(result)")
                    DispatchQueue.main.async {
                        completion(result, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, "No Data")
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    var message = String.giveMeProperString(str: error?.localizedDescription)
                    if message.isEmpty {
                        message = Constants.MSG_DEFAULT
                    }
                    completion(nil, message)
                }
            }
        })
        dataTask.resume()
    }
    
}

extension APIManager {
    enum Error: Swift.Error {
        case noInternet
        case noValidURL
        case noData
        case requestFailed
        case jsonSerializatoinFailed
    }
}

extension APIManager.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Internet connection appears to be offline"
        case .noValidURL:
            return "Not a valid URL"
        case .noData:
            return "No Data"
        case .requestFailed:
            return "no status info in JSON response"
        case .jsonSerializatoinFailed:
            return "Failed to convert data to json"
        }
    }
}
