//
//  Constants.swift
//

import Foundation
import UIKit

struct Constants
{
    static let APP_STORE_URL = "www.apple.com"
    static var APP_URL : String {
       return "\(BaseClass.shared.strUrl)"
    }
    static var IMAGE_URL : String {
        return BaseClass.shared.strUrl
    }
  
//    //default colors
//    static let COLOR_NAV = UIColor(named: "db5105")
//    static let COLOR_TITLE = UIColor(named: "ffffff")
//    static let COLOR_TRANSPERENT_TITLE = UIColor(hex: "000000")
//    static let COLOR_SHADOW = UIColor(hex: "c6cac8")
    
    static let TOAST_DURATION = 3.0
    static let TIME_OUT = 10.0
    static let GET = "GET"
    static let POST = "POST"
    static let DELETE = "DELETE"
    static let PUT = "PUT"
    static let UPDATE = "UPDATE"
    
    static let CONTENT_TYPE_JSON = "application/json"
    static let CONTENT_TYPE_ENCODING = "application/x-www-form-urlencoded"
    static let CONTENT_TYPE_FORM = "multipart/form-data"
    
    //Fonts
    static let FONT_STYLE = "HelveticaNeue"
    static let BOLD_FONT_STYLE = "HelveticaNeue-Bold"
    static let MEDIUM_FONT_STYLE = "HelveticaNeue-Medium"
    static let NORMAL_FONT_SIZE : CGFloat = 17.0
    
    //Messages
    static let MSG_NO_INTERNET = "Check your internet connection."
    static let MSG_NO_DETAILS = "No details are available."
    static let MSG_EMPTY = "Fields cannot be empty."
    static let MSG_DEFAULT = "Something went wrong, please try again later."
    static let UNPASS_WRONG = "Username or Password is wrong."

}

struct ScreenSize
{
    static var SCREEN_WIDTH : CGFloat {
        return UIScreen.main.bounds.size.width
    }
    static var SCREEN_HEIGHT : CGFloat {
        return UIScreen.main.bounds.size.height
    }
    static let SCREEN_MAX_LENGTH = max (ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD_AIR = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_LANDSCAPE = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
    static let IS_PORTRAIT = UIDevice.current.orientation == UIDeviceOrientation.portrait
}
