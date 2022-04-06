//
//  Helpers.swift
//  groceryapp
//
//  Created by Hamza Arif on 01/01/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import UIKit
import CDAlertView
import Alamofire
import Kingfisher
import Toast_Swift
import JGProgressHUD

class Helpers{

    static var main_url = "https://app2.atlanticcity.com/"
    static var currency_sign = "$"
    
    
    static var shared_maps_key="AIzaSyAWI2bnyzFY6HKq8lBUMY1YI79vlTIoOBU"
    
    static var black=0x333333
    static var white=0xFFFFFF
    static var green=0x1CB171
    
    static let preferences = UserDefaults.standard
    static let headers: HTTPHeaders = [
        "Authorization": "Basic NmY0ZjM2ODcyODE1NTc1MzFlMmNjODk3MjJhM2U4YzYyZDQ3OGQ1YTo3YzNhMTI4ZGExYTQ0MDk2ZDJlZThhNDU0OGJiMDlhNTY2NzkyMjRh"
    ]
    static let progressHUD = JGProgressHUD(style: .dark)
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    static func writePreference(key: String,data: String){
        
        preferences.set(data, forKey: key)
        preferences.synchronize()
    }
    static func readPreference(key:String,defualt:String) -> String{
        
        if preferences.object(forKey: key) == nil {
            return defualt
        } else {
            let current = preferences.string(forKey: key)
            return current!
        }
    }
    
    static func showAlertView(title:String,message:String){
        let alert = CDAlertView(title:title, message: message, type: .error)
         alert.hideAnimations = { (center, transform, alpha) in
             transform = CGAffineTransform(scaleX: 2, y: 2)
             alpha = 0
         }
        alert.hideAnimationDuration = 0.5
        alert.autoHideTime = 1
        alert.show()
    }
    static func showSuccessView(title:String,message:String){
        let alert = CDAlertView(title:title, message: message, type: .success)
           alert.hideAnimations = { (center, transform, alpha) in
               transform = CGAffineTransform(scaleX: 2, y: 2)
               alpha = 0
           }
          alert.hideAnimationDuration = 0.5
          alert.autoHideTime = 1
          alert.show()
      }
    static func showSuccessAlertView(title:String,subTitle:String){
      
    }
    
    static func showHUD(view:UIView,progressLabel:String){
        progressHUD.textLabel.text = progressLabel
        progressHUD.show(in: view)
    }
    static func dismissHUD(view:UIView,isAnimated:Bool) {
        progressHUD.dismiss(animated: true)
    }
    static func showToast(view:UIView,msg:String){
        view.makeToast(msg, duration: 1.0, position: .center)
    }
}

