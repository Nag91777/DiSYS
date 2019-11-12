//
//  ProperString+String.swift
//

import Foundation

extension String {
    
    static func giveMeProperString(str : Any?) -> String {
        guard let str = str else {
            return ""
        }
        if str is String{
            return str as! String
        }else if str is NSNumber {
            return "\(str)"
        }
        return ""
    }
    
}
