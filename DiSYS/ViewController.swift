//
//  ViewController.swift
//  DiSYS
//
//  Created by MNRAO on 12/11/19.
//  Copyright © 2019 Defteam. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    
    var selectedField : UITextField?
    var keyboardHeight = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.addKeyboardListener()
        setKeychainDefaults(username: "Admin", password: "Admin")
    }
    
    func setKeychainDefaults(username: String, password: String){
        KeychainWrapper.standard.set(username, forKey: "UserName")
        KeychainWrapper.standard.set(password, forKey: "Password")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtUserName.text = ""
        txtPassword.text = ""
    }
    
    func initialize() {
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = Int(keyboardRectangle.height)
        scrollView.contentSize = CGSize(width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT+CGFloat(keyboardHeight))
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        scrollView.contentSize = CGSize(width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
    }
    
    deinit {
        self.removeKeyboardListener()
    }
    
    @IBAction func signInTapped(sender : UIButton){

        selectedField?.resignFirstResponder()
        if
            let username = txtUserName.text,
            let password = txtPassword.text,
            username.count > 0,
            password.count > 0{
            loginService(username: username, password: password)
        }else{
            self.view.makeToast(Constants.MSG_EMPTY, duration: Constants.TOAST_DURATION, position: .bottom)
        }
    }
    
    func loginService(username: String, password: String){
        if
            let keychainUsername = KeychainWrapper.standard.string(forKey: "UserName"),
            let keychainPassword = KeychainWrapper.standard.string(forKey: "Password"),
            keychainUsername.count > 0,
            keychainPassword.count > 0 {
            handleUsePass(kUsername: keychainUsername, kPassword: keychainPassword, userName: username, passwod: password)
        }else{
            self.view.makeToast(Constants.MSG_NO_DETAILS, duration: Constants.TOAST_DURATION, position: .center)
        }
    }

    func handleUsePass(kUsername: String, kPassword: String, userName: String, passwod: String){
        if userName == kUsername  && passwod == kPassword{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newsViewController = storyBoard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
            self.present(newsViewController, animated: true, completion: nil)
        }else{
            self.view.makeToast(Constants.UNPASS_WRONG, duration: Constants.TOAST_DURATION, position: .bottom)
        }
    }

}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedField = textField
    }
    
}
