//
//  AddApiViewController.swift
//  DiSYS
//
//  Created by MNRAO on 12/11/19.
//  Copyright © 2019 Defteam. All rights reserved.
//

import UIKit

class AddApiViewController: UIViewController {
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var eidTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var idbarahTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var unifiedTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    
    var keyboardHeight = 0
    var selectedField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardListener()
    }
    
    @IBAction func cacleTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func keyboardWillShow(_ notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = Int(keyboardRectangle.height)
        scrollView.contentSize = CGSize(width: ScreenSize.SCREEN_WIDTH, height: 300 + CGFloat(keyboardHeight))
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        scrollView.contentSize = CGSize(width: ScreenSize.SCREEN_WIDTH, height: 300)
    }
    
    deinit {
        self.removeKeyboardListener()
    }

    func validateFileds(){
        if
            let eid = eidTxt.text, eid.count > 0,
            let name = nameTxt.text, name.count > 0,
            let idbarah = idbarahTxt.text, idbarah.count > 0,
            let email = emailTxt.text, email.count > 0,
            let unified = unifiedTxt.text, unified.count > 0,
            let mobile = mobileTxt.text, mobile.count > 0
        {
            if BaseClass.shared.validateEmailWithString(email: email){
                callService(eid: eid, name: name, idbarah: idbarah, email: email, unified: unified, mobile: mobile)
            } else {
                self.view.makeToast("Please enter a valid Email.")
            }
        }else{
            self.view.makeToast(Constants.MSG_NO_DETAILS, duration: Constants.TOAST_DURATION, position: .bottom)
        }
    }
    
    @IBAction func SubmitAction(_ sender: Any) {
        selectedField?.resignFirstResponder()
        validateFileds()
        
    }
    
    
    func  callService(eid: String, name: String, idbarah: String, email: String, unified: String, mobile: String) {
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "consumer-key": "mobile_dev_dysis",
            "consumer-secret": "8c6e5807397f41dfbc7f61cc049c7ef0",
            "cache-control": "no-cache",
            "postman-token": "d3a68234-0677-decd-cdf6-cb38f48d6e89"
        ]
        
        let postData = NSMutableData(data: "eid=\(eid)".data(using: String.Encoding.utf8)!)
        postData.append("&name=\(name)".data(using: String.Encoding.utf8)!)
        postData.append("&idbarahno=\(idbarah)".data(using: String.Encoding.utf8)!)
        postData.append("&emailaddress=\(email)".data(using: String.Encoding.utf8)!)
        postData.append("&unifiednumber=\(unified)".data(using: String.Encoding.utf8)!)
        postData.append("&mobileno=\(mobile)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.qa.mrhe.gov.ae/mrhecloud/v1.4/api/iskan/v1/certificates/towhomitmayconcern?local=en")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if error == nil && response != nil, let data = data {
                var result: Any?
                do{
                    result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch {
                    DispatchQueue.main.async {
                        self.view.makeToast("Failed to convert data to json", duration: Constants.TOAST_DURATION, position: .bottom)
                    }
                    return
                }
                if let result = result as? [String: Any]  {
                    print("result: \(result)")

                    let status = String.giveMeProperString(str: result["success"])
                    if status == "1"{
                        DispatchQueue.main.async {
                            self.view.makeToast(String.giveMeProperString(str: result["message"]), duration: Constants.TOAST_DURATION, position: .bottom)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.TOAST_DURATION, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }else{
                        let error = String.giveMeProperString(str: result["message"])
                        if error == "API.Common.InvalidMobileNo"{
                            DispatchQueue.main.async { self.view.makeToast("Please enter a valid mobile number", duration: Constants.TOAST_DURATION, position: .bottom)
                            }
                        }else{
                            DispatchQueue.main.async { self.view.makeToast(String.giveMeProperString(str: result["message"]), duration: Constants.TOAST_DURATION, position: .bottom)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view.makeToast("No Data", duration: Constants.TOAST_DURATION, position: .bottom)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    

}

extension AddApiViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedField = textField
    }
    
}
