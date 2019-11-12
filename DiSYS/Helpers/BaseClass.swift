//
//  BaseClass.swift
//  HGS
//
//  Copyright © 2019 DEFTeam. All rights reserved.
//

import UIKit
//import SwiftKeychainWrapper

class BaseClass: NSObject {
    
    static let shared = BaseClass()
    
    //var userModel: UserModel!
    var appDateFormat = ""
    var strUrl = ""
    var isTestDerive : Bool!
    var currentLanCode = ""
    var deviceToken = ""
    var userRole = ""
    var isRoleAdmin : Bool!
    var isRoleAgent : Bool!
    
    
    func validateEmailWithString(email: String) -> Bool {
      
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
                    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                    let result = emailTest.evaluate(with: email)
                 return result
    }


   
}

